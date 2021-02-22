//
//  CravyFirebase.swift
//  Cravy-Partner
//
//  Created by Cravy on 22/02/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import Foundation
import FirebaseFunctions
import FirebaseStorage
import FirebaseAuth
import PromiseKit

class CravyFirebase {
    internal let functions = Functions.functions()
    internal let auth = Auth.auth()
    private var metadata: StorageMetadata {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        return metadata
    }
    
    init() {
        functions.useEmulator(withHost: "http://localhost", port: 5001)
        auth.useEmulator(withHost:"localhost", port: 9099)
    }
    
    /// Sign in the user with email and password.
    func signIn(email: String, password: String) -> Promise<AuthDataResult> {
        return Promise { (seal) in
            auth.signIn(withEmail: email, password: password, completion: seal.resolve)
        }
    }
    
    /// Update the user email.
    func updateEmail(to email: String) -> Promise<Void> {
        return Promise { (seal) in
            auth.currentUser!.updateEmail(to: email, completion: seal.resolve)
        }
    }
    
    /// Stores the image on the database in the provided URL.
    /// - Parameters:
    ///   - imageURL: The location of where the image is stored.
    func saveImage(on imageURL: String, image: UIImage) throws -> Promise<Data> {
        return Promise { (seal) in
            let data = try compress(image)
            Storage.storage().reference(forURL: imageURL).putData(data, metadata: metadata) { (metadata, error) in
                if let e = error {
                    seal.reject(e)
                } else {
                    seal.fulfill(data)
                }
            }
        }
    }
    
    /// Stores the image on the database and returns the newly created URL for the image.
    func saveImage(_ image: UIImage, at path: String) throws -> Promise<URL?> {
        let data = try compress(image)
        let imageRef = Storage.storage().reference(withPath: path).child("\(UUID().uuidString).jpeg")
        return Promise { (seal) in
            imageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let e = error {
                    seal.reject(e)
                } else {
                    imageRef.downloadURL { (url, error) in
                        seal.fulfill(url)
                    }
                }
            }
        }
    }
    
    /// Stores the image on the database and returns the newly created data of the image.
    func saveImage(_ image: UIImage, at path: String) throws -> Promise<Data> {
        let data = try compress(image)
        let imageRef = Storage.storage().reference(withPath: path).child("\(UUID().uuidString).jpeg")
        return Promise { (seal) in
            imageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let e = error {
                    seal.reject(e)
                } else {
                    imageRef.downloadURL { (url, error) in
                        self.functions.httpsCallable("setBusinessLogo").call([K.Key.logoURL : url?.absoluteString]) { (result, error) in
                            if let e = error {
                                seal.reject(e)
                            } else {
                                seal.fulfill(data)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Stores the image on the database and returns the newly created data and url of the image.
    func saveImage(_ image: UIImage, at path: String) throws -> Promise<(Data, URL?)> {
        let data = try compress(image)
        let imageRef = Storage.storage().reference(withPath: path).child("\(UUID().uuidString).jpeg")
        return Promise { (seal) in
            imageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let e = error {
                    seal.reject(e)
                } else {
                    imageRef.downloadURL { (url, error) in
                        self.functions.httpsCallable("setBusinessLogo").call([K.Key.logoURL : url?.absoluteString]) { (result, error) in
                            if let e = error {
                                seal.reject(e)
                            } else {
                                seal.fulfill((data, url))
                            }
                        }
                    }
                }
            }
        }
    }
    
    //TODO Timeout Error
    private func compress(_ image: UIImage, cq: CGFloat = 1) throws -> Data {
        guard let compressedData = image.jpegData(compressionQuality: cq) else {throw CravyError.imageDataCorruptedError}
        if compressedData.size(in: .byte) > Double(Int64.MAX_IMAGE_SIZE) {
            return try compress(image, cq: cq-0.01)
        } else {
            return compressedData
        }
    }
}
