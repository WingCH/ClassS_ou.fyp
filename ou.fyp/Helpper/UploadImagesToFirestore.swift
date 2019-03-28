//
//  UploadImagesToFirestore.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 20/2/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import Foundation
import Firebase

// https://stackoverflow.com/questions/29726643/how-to-compress-of-reduce-the-size-of-an-image-before-uploading-to-parse-as-pffi
// 壓縮至特定大小(mb)
extension UIImage {
    // MARK: - UIImage+Resize
    func compressTo(_ expectedSizeInMb:Int) -> Data? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return data
            }
        }
        return nil
    }
}

class UploadImagesToFirestore: NSObject {
    
    static func saveImages(uid:String, persistedFaceIds_Source:[String:UIImage], result:@escaping ([String:String])->()){
        
        uploadImagesToFirestore(userId: uid,persistedFaceIds_Source : persistedFaceIds_Source){ (uploadedImageUrlsArray) in
            print("uploadedImageUrlsArray: \(uploadedImageUrlsArray)")
            result(uploadedImageUrlsArray)
        }
    }
}


func uploadImagesToFirestore(userId: String, persistedFaceIds_Source:[String:UIImage], completionHandler: @escaping ([String:String]) -> ()){
    let storage     =   Storage.storage()
    
    var uploadedImageUrlsArray = [String:String]()
    var uploadCount = 0
    let imagesCount = persistedFaceIds_Source.count
    
    for (key, value) in persistedFaceIds_Source{
        
        //Create storage reference for image
        let storageRef = storage.reference().child("students").child("\(userId)").child("\(key).jpg")
        
        guard let uplodaData = value.jpegData(compressionQuality: 1) else{
            return
        }
        
        // Upload image to firebase
        _ = storageRef.putData(uplodaData, metadata: nil, completion: { (metadata, error) in
            if error != nil{
                print(error!)
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                guard url != nil else {
                    // Uh-oh, an error occurred!
                    return
                }
                uploadedImageUrlsArray[key] = url?.absoluteString
                uploadCount += 1
                print("Number of images successfully uploaded: \(uploadCount)")
                if uploadCount == imagesCount{
                    NSLog("All Images are uploaded successfully, uploadedImageUrlsArray: \(uploadedImageUrlsArray)")
                    completionHandler(uploadedImageUrlsArray)
                }
            })
            
        })
    }
}
