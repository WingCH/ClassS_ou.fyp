//
//  ViewController.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 5/1/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SwiftyJSON

//class Student: Codable{
//    let personId:String
//    let studentID:String
//    let name:String
//    let persistedFaceIds:[String]
//    let email:String
//    init(personId:String, studentID:String, name:String, persistedFaceIds:[String], email:String) {
//        self.personId = personId
//        self.studentID = studentID
//        self.name = name
//        self.persistedFaceIds = persistedFaceIds
//        self.email = email
//    }
//}
class LoginViewController: UIViewController, GIDSignInUIDelegate{

    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var test: NSLayoutConstraint!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide NavigationBar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        

        
        handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            print(auth)
            if let user = user {
                print("✉️: ", user.email!, "is logined")
                let usersRef =  Firestore.firestore().collection("users").document(user.uid)
                
                usersRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()

//                        let json = JSON(arrayLiteral: data!)
//                        let my = Student(personId: json[0]["personId"].string!, studentID: json[0]["studentID"].string!, name: json[0]["name"].string!, persistedFaceIds: json[0]["persistedFaceIds"].arrayObject! as! [String], email: json[0]["email"].string!)
//                        print(my.persistedFaceIds[0])
//                        
////                        let defaults = Defaults()
////                        let key = Key<String>("loginedUserData")
////                        defaults.set(my, for: key)
//                        
//                        let defaults = Defaults() // or Defaults.shared
//                        // Define a key
//                        let key = Key<String>("loginedUserData")
//                        
//                        // Set a value
//                        defaults.set("Codable FTW 😃", for: key)
//                        
//                        // Read the value back
//                        defaults.get(for: key) // Output: Codable FTW 😃
//                        
                        
                        
                        self.performSegue(withIdentifier: "LoginToMain", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "LoginToReg", sender: self)
                    }
                }
                
            }else{
                print("logouted")
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func bResingTap(_ sender: Any) {
        userName.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    @IBAction func googleSignin(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }

}

