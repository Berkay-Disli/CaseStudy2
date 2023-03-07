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
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var userProfileImageUrl: URL?
    @Published var loadingAnimation = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var directLogin = true
    
    @Published var cardsList: [CardItem] = []
    @Published var usersList: [AppUser] = []
    
    @Published var cardToShow: CardItem?
    
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
            changeRequest?.displayName = fullname
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
    
    func getAllUsers() async throws {
        do {
            let snapshot = try await Firestore.firestore().collection("users").getDocuments()
            await MainActor.run(body: {
                self.usersList.removeAll(keepingCapacity: false)
            })

            for document in snapshot.documents {
                guard let displayName = document.get("fullname") as? String else { return }
                guard let email = document.get("email") as? String else { return }
                guard let profilePicURLString = document.get("profilePicUrl") as? String else { return }
                let userToAdd = AppUser(displayName: displayName, email: email, profilePicURLString: profilePicURLString)
                
                await MainActor.run(body: {
                    self.usersList.append(userToAdd)
                })
            }
            await MainActor.run(body: {
                self.usersList.reverse()
            })
        } catch {
            
        }
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            loadingAnimation = false
        })
    }
    
    // Onboarding View Timing
    func setDirectLogin(_ bool: Bool) {
        directLogin = bool
    }
    
    // MARK: ------------- Data Functions -----------------
    
    func getCardsFromFirestore() async throws {
        do {
            let snapshot = try await Firestore.firestore().collection("posts").getDocuments()
            await MainActor.run(body: {
                self.cardsList.removeAll(keepingCapacity: false)
            })
            
            for document in snapshot.documents {
                guard let hex = document.get("color") as? String else { return }
                guard let title = document.get("title") as? String else { return }
                guard let description = document.get("description") as? String else { return }
                guard let image = document.get("image") as? String else { return }
                guard let author = document.get("author") as? String else { return }
                
                let cardToAdd = CardItem(color: Color(hex: hex) ?? .black, title: title, description: description, data: Data(), author: author, image: image)
                
                await MainActor.run(body: {
                    self.cardsList.append(cardToAdd)
                })
            }
            await MainActor.run(body: {
                self.cardsList.reverse()
            })
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func postCardToFirestore(_ cardItem: CardItem) async throws {
        guard let displayName = Auth.auth().currentUser?.displayName else { return }
        await MainActor.run(body: {
            loadingAnimation = true
        })
        let postPath = givePostPathByDate()
        
        do {
            let imgUrl = try await uploadImageToStorage(dataForImage: cardItem.data, postPath: postPath)
            guard let hexColorValue = cardItem.color.toHex() else { return }
            let postData = ["color": hexColorValue, "title": cardItem.title, "description": cardItem.description, "image": imgUrl, "author": displayName] as [String:Any]
            
            try await Firestore.firestore().collection("posts").document(postPath).setData(postData)
            
        } catch {
            print(error)
            throw error
        }
        
        await MainActor.run(body: {
            loadingAnimation = false
        })
    }
    
    private func uploadImageToStorage(dataForImage: Data, postPath: String) async throws -> String {
        let ref = Storage.storage().reference(withPath: "posts/\(postPath).jpg")
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
    
    func setCardToShow(_ cardItem: CardItem) {
        self.cardToShow = cardItem
    }
    
    func clearCardToShow() {
        self.cardToShow = nil
    }
}

#warning("create a firebase manager")
