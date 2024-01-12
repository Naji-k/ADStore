//
//  FirebaseHelper.swift
//  ADStore
//
//  Created by Naji Kanounji on 1/12/24.
//  Copyright © 2024 Naji Kanounji. All rights reserved.
//

import UIKit
import Firebase

class FirebaseHelper {

    class func uploadImageToFirebaseStorage(image: UIImage?, child: String,  completion: @escaping (String?) -> Void) {
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child(child).child("\(imageName).jpg")
        if let adsImage = image, let uploadData = adsImage.jpegData(compressionQuality: 0.7) {
            storageRef.putData(uploadData, metadata: nil) { _, err in
                if let error = err {
                    print("error upload image to Firebase storage ",error)
                    completion(nil)
                    return
                }
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("error download imageURL ",error)
                        completion(nil)
                        return
                    }
                    guard let url = url?.absoluteString else {
                        completion(nil)
                        return
                    }
                    completion(url)
                }
            }
        }
    }
}
