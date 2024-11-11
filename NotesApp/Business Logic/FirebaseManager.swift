//
//  FirebaseManager.swift
//  NotesApp
//
//  Created by Vladislav on 06.10.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import Firebase

protocol FirebaseManager {
    func currentUser() -> String
    func isSignIn() -> Bool
    func registration(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void)
    func autorization(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void)
    func signOut() -> Result<Void,Error>
    func addNote<T: Encodable>(entity: T, id: String) -> Result<Void, Error>
    func deleteNote(id: String) -> Result<Void, Error>
    func deleteAllNotes()
    func updateNote<T: Encodable>(entity: T, id: String) -> Result<Void, Error>
    func updateNotes<T: Encodable>(entities: [T]) -> Result<Void, Error>
    func fetchDataFromFB(completion: @escaping (Result<[NotesCellData], Error>) -> Void)
}

final class FirebaseManagerImpl: FirebaseManager {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let ref = Database.database().reference()
    
    func currentUser() -> String {
        
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser?.email ?? ""
        } else {
            return ""
        }
    }
    
    func isSignIn() -> Bool {
        
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
    
    func registration(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {

         Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in

            let db = Firestore.firestore()
            if let result = result {
                db.collection("Users").addDocument(data: [
                    "Email": email,
                    "password": password,
                    "uid": result.user.uid])
                completion(.success(result))
            }
            else if let error = error {

                completion(.failure(error))
            }
        }
    }
    
    func autorization(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            
            if let result = result {
                
                completion(.success(result))
            }
            else if let error = error {
                
                completion(.failure(error))
            }
        }
    }
    
    func signOut() -> Result<Void,Error> {
        
        do {
            try Auth.auth().signOut()
            return .success(())
        } catch  {
            return .failure(FBError.unauthorized)
        }
    }
    
    func addNote<T: Encodable>(entity: T, id: String) -> Result<Void, Error> {
        
        if let userID = Auth.auth().currentUser?.uid {
            
            do {
                let data = try encoder.encode(entity)
                guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                    return .failure(FBError.encodeError) }
                ref.child(userID).child(id).setValue(dict)
            } catch {
                return .failure(FBError.createError)
            }
        } else {
            return .failure(FBError.unauthorized)
        }
        return .success(())
    }
    
    func deleteNote(id: String) -> Result<Void, Error> {
        
       if let userID = Auth.auth().currentUser?.uid {
            
            ref.child(userID).child(id).removeValue()
           return .success(())
        }
        return .failure(FBError.unauthorized)
    }
    
    func deleteAllNotes() {
        
        if let userID = Auth.auth().currentUser?.uid {
            ref.child(userID).removeValue()
        }
    }
    
    func updateNote<T: Encodable>(entity: T, id: String) -> Result<Void, Error> {

        if let userID = Auth.auth().currentUser?.uid {
            
            do {
                let data = try encoder.encode(entity)
                guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                    return .failure(FBError.encodeError)
                }
                ref.child(userID).child(id).updateChildValues(dict)
                return .success(())
            } catch {
                return .failure(FBError.createError)
            }
        }
        return .failure(FBError.unauthorized)
    }
    
    func updateNotes<T: Encodable>(entities: [T]) -> Result<Void, Error> {

        if let userID = Auth.auth().currentUser?.uid {
            do {
                let dataEncode = try encoder.encode(entities)
                guard let dicts = try JSONSerialization.jsonObject(with: dataEncode, options: .allowFragments) as? [[String: Any]] else {
                    return .failure(FBError.encodeError)
                }
                let data = dicts.reduce([:], { result, element -> [String: Any] in
                    var mod = result
                    let _element = element
                    if let id = _element["id"] as? String {
                        mod[id] = _element
                    }
                    return mod
                })
                ref.child(userID).updateChildValues(data)
                return .success(())
            } catch {
                return .failure(FBError.createError)
            }
        }
        return .failure(FBError.unauthorized)
    }
    
    func fetchDataFromFB(completion: @escaping (Result<[NotesCellData], Error>) -> Void) {
        
        if let userID = Auth.auth().currentUser?.uid {
            
            ref.child(userID).getData { error, snapshot in
                
                if let error = error {
                    completion(.failure(error))
                } else {
                    guard let dic = snapshot?.value as? [String: Any] else { return }
                    let data = dic.reduce([], { result, element -> [[String: Any]] in
                        var mod = result
                        let id = element.key
                        if var dict = element.value as? [String: Any] {
                            dict["id"] = id
                            mod.append(dict)
                        }
                        return mod
                    })
                    do {
                        let ser = try JSONSerialization.data(withJSONObject: data,
                                                             options: .fragmentsAllowed)
                        let decoded = try self.decoder.decode([NotesCellData].self,from: ser)
                        completion(.success(decoded))
                    } catch {
                        completion(.failure(FBError.decodeError))
                    }
                }
            }
        } else {
            completion(.failure(FBError.unauthorized))
        }
    }
    
}

enum FBError: LocalizedError {
    
    case encodeError
    case unauthorized
    case deleteFromFB
    case loadError
    case decodeError
    case createError
    case autorization
    case createAccount
    
    var errorDescription: String? {
        switch self {
        case .encodeError:
            return "Failed to encode data".localized()
        case .unauthorized:
            return "User is not authorized".localized()
        case .deleteFromFB:
            return "Error removing from FireBase".localized()
        case .loadError:
            return "Error loading from FireBase".localized()
        case .decodeError:
            return "Failde to decode data".localized()
        case .createError:
            return "Failed to create data".localized()
        case .autorization:
            return "Failed to autorization user".localized()
        case .createAccount:
            return "Failed to create account"
        }
    }
}
