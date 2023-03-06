//
//  AuthViewModel.swift
//  DepixenCaseStudy
//
//  Created by Berkay Disli on 5.03.2023.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var userProfileImageUrl: URL?
    @Published var loadingAnimation = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var directLogin = true
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.userProfileImageUrl = nil
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    // MARK: Async Email Sign Up
    func createAccountWithEmailAsync(email: String, username: String, fullname: String, password: String, image: UIImage) async throws {
        do {
            await MainActor.run(body: {
                self.loadingAnimation = true
            })
            // create user with email
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = result.user
            // create a change request for giving the user a username
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            try await changeRequest?.commitChanges()
            
            // continue with uploaduserinfowithpicture
            await self.uploadFullUserInfoWithPictureAsync(user: user, email: email, username: username, fullname: fullname, image: image)
            
            try await Task.sleep(for: .seconds(1))
            
            await MainActor.run(body: {
                self.userSession = user
            })
            try await self.getUserInfoAsync()
            await MainActor.run(body: {
                self.loadingAnimation = false
            })
        } catch {
            print("AUTH ERROR:\(error.localizedDescription)")
            throw error
        }
    }
    
    
    // MARK: Async Email Sign In
    func signInWithEmailAsync(email: String, password: String) async throws {
        do {
            await MainActor.run(body: {
                self.loadingAnimation = true
            })
            
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = result.user
            
            await MainActor.run(body: {
                self.userSession = user
            })
            
            await MainActor.run(body: {
                self.userSession = user
            })
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    
    // MARK: Upload User Info to Firestore Async
    private func uploadUserInfoToFirestoreAsync(user: User, email: String, username: String, fullname: String, imgUrl: String) async {
        let userData = ["email": email, "username": username, "fullname": fullname, "profilePicUrl": imgUrl] as [String:Any]
        
        do {
            try await Firestore.firestore().collection("users").document(user.uid).setData(userData)
        } catch {
            print(error)
        }
    }
    
    
    // MARK: Upload Full User Info w/ Picture Async
    private func uploadFullUserInfoWithPictureAsync(user: User, email: String, username: String, fullname: String, image: UIImage) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Storage.storage().reference(withPath: "users/\(uid).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            let _ = try await ref.putDataAsync(imageData)
            let result = try await ref.downloadURL()
            let imgUrl = result.absoluteString
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.photoURL = result
            try await changeRequest?.commitChanges()
            
            await uploadUserInfoToFirestoreAsync(user: user, email: email, username: username, fullname: fullname, imgUrl: imgUrl)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Get User Info Async
    func getUserInfoAsync() async throws {
        guard let user = userSession else { return }
        
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(user.uid).getDocument()
            guard let userProfileImg = snapshot.get("profilePicUrl") as? String else { return }
            
            await MainActor.run(body: {
                self.userProfileImageUrl = URL(string: userProfileImg)
            })
        } catch {
            print(error)
        }
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            loadingAnimation = false
        })
    }
    
    func deleteUser() async throws {
        guard let uid = userSession?.uid else { return }
        
        let ref = Storage.storage().reference(withPath: "userImages/\(uid).jpg")
        do {
            try await ref.delete()
            try await Firestore.firestore().collection("users").document(uid).delete()
            try await Auth.auth().currentUser?.delete()
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func setDirectLogin(_ bool: Bool) {
        directLogin = bool
    }
    
    // MARK: ------------- Data Functions -----------------
    
    // Posting the card item to firestore
    func postCardToFirestore(_ cardItem: CardItem) async throws {
        guard let displayName = Auth.auth().currentUser?.displayName else { return }
        
        do {
            let imgUrl = try await uploadImageToStorage(dataForImage: cardItem.image)
            guard let hexColorValue = cardItem.color.toHex() else { return }
            let postData = ["color": hexColorValue, "title": cardItem.title, "description": cardItem.description, "image": imgUrl, "author": displayName] as [String:Any]
            
            try await Firestore.firestore().collection("posts").document(givePostPathByDate()).setData(postData)
            
        } catch {
            print(error)
            throw error
        }
    }
    #warning("IMPORTANT: Date formatter uses / and it makes firestore create new documents. FIX IT!")
    /*
     let myString = "aaaaaaaabbbb"
     let replaced = myString.replacingOccurrences(of: "bbbb", with: "")
     ------
     var str = "An apple a day, keeps doctor away!"
     let removeCharacters: Set<Character> = ["p", "y"]
     str.removeAll(where: { removeCharacters.contains($0) } )
     */
    private func uploadImageToStorage(dataForImage: Data) async throws -> String {
        let ref = Storage.storage().reference(withPath: "posts/\(givePostPathByDate()).jpg")
        guard let dataToImage = UIImage(data: dataForImage) else { throw URLError(.cannotCreateFile)}
        guard let imageData = dataToImage.jpegData(compressionQuality: 0.5) else { throw URLError(.badURL)}
        
        do {
            let _ = try await ref.putDataAsync(imageData)
            let result = try await ref.downloadURL()
            //let url = result.downloadURL
            
            return result.absoluteString
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    private func givePostPathByDate() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateStyle = DateFormatter.Style.short
        df.timeStyle = DateFormatter.Style.short
        
        var pathToPost = df.string(from: date)
        let removeCharacters: Set<Character> = ["/", " "]
        pathToPost.removeAll(where: { removeCharacters.contains($0) } )
        
        return pathToPost
    }
}
