//
//  TestViewController.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 1/2/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Alamofire
import SwiftyJSON

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "no_face.jpg")

        //Face - Detect
//        AzureFaceRecognition.shared.faceDetect(faceImageData: (image?.jpegData(compressionQuality: 1))!, result: {data, error in
//
//            guard error == nil else {
//                print(error!)
//                return
//            }
//
//            guard data!["error"].exists() == false else {
//                print(data!["error"])
//                return
//            }
//
//            guard data!.count == 1 else{
//                print("圖片有\(data!.count)個人臉，只容許有一張人臉，請重拍")
//                return
//            }
//
//            if let faceId = data![0]["faceId"].string {
//                print(faceId)
//            }
//        })
        
        //PersonGroup Person - Create
//        AzureFaceRecognition.shared.personCreate(name: "TEST", userData: "", result: {data, error in
//
//            guard error == nil else {
//                print(error!)
//                return
//            }
//
//            guard data!["error"].exists() == false else {
//                print(data!["error"])
//                return
//            }
//
//            print(data!["personId"])
//
//
//
//        })
    
        
        
        //PersonGroup Person - List
//        AzureFaceRecognition.shared.personsList(result: {data, error in
//            print(data!)
//            print(error as Any)
//        })
    
        //PersonGroup Person - Delete
//        AzureFaceRecognition.shared.personsDelete(personId: "bc660c31-030a-4354-a456-acc6c94d0eb0", result: { error in
//            if error == nil{
//                print("sccuess")
//            }
//        })
        
        
        
//      PersonGroup Person - Add Face
//        AzureFaceRecognition.shared.personAddFace(personId: "f5311f19-8d03-41d3-b29c-488213ca70b5", faceImageData: (image?.jpegData(compressionQuality: 1))!, result: {data, error in
//            guard error == nil else {
//                print(error!)
//                return
//            }
//
//            guard data!["error"].exists() == false else {
//                print(data!["error"])
//                return
//            }
//
//            if let faceId = data![0]["persistedFaceId"].string {
//                print(faceId)
//            }
//        })
        
        //PersonGroup - Train
//        AzureFaceRecognition.shared.personGroupTrain(result: {error in
//            if error == nil{
//                print("PersonGroup - Train called")
//            }
//        })
        
        
        //PersonGroup - Get Training Status
//        AzureFaceRecognition.shared.personGroupTrainingStatus(result: {data, error in
//            guard error == nil else {
//                print(error!)
//                return
//            }
//
//            guard data!["error"].exists() == false else {
//                print(data!["error"])
//                return
//            }
//            print(data!)
//        })
        
        //Face - Identify
//        AzureFaceRecognition.shared.faceIdentify(faceIds: ["9b0ebd9e-e70a-4191-9d48-09f94fd0ee1e"], maxNumOfCandidatesReturned: 1, result: { data, error in
//            guard error == nil else {
//                print(error!)
//                return
//            }
//
//            guard data!["error"].exists() == false else {
//                print(data!["error"])
//                return
//            }
//            print(data)
//        })
        
    }
    
    
    
    
    @IBAction func logout(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        do {
            //https://stackoverflow.com/questions/49827821/why-my-google-sign-in-doesnt-show-account-selection-after-i-successfully-sign-i
            GIDSignIn.sharedInstance()?.signOut()
            try firebaseAuth.signOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
