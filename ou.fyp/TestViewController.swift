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

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "Family1-Dad1.jpg")
//        AzureFaceRecognition.shared.faceDetect(faceImageData: (image?.jpegData(compressionQuality: 1))!, result: {result in
//            print(result)
//        })
        AzureFaceRecognition.shared.faceDetect(faceImageData: (image?.jpegData(compressionQuality: 1))!, result: {result in
            
        })
        
//        AzureFaceRecognition.shared.faceDetect_3()
//        AzureFaceRecognition.shared.listPersonGroup()

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
