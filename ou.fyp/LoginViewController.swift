//
//  ViewController.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 5/1/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import AutoKeyboard
import Firebase
import GoogleSignIn

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
        
        registerAutoKeyboard(enable: [test], disable: []) { (result) in
            print("keyboard status \(result.status)")
        }
        
        handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            print(auth)
            if let user = user {
                print("✉️: ", user.email!, "is logined")
                let usersRef =  Firestore.firestore().collection("users").document(user.uid)
                
                usersRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        
                        self.performSegue(withIdentifier: "LoginToMain", sender: self)
                    } else {
                        //firestore(/users/userid) 未有user 資料
                        //init user 寫入user data to firestore
//                        usersRef.setData([
//                            "email": user.email!,
//                            "name": user.displayName!,
//                            "faces": []
//                        ]) { err in
//                            if let err = err {
//                                print("Error writing document: \(err)")
//                            } else {
//                                print("寫入user data to firestore")
//                                self.performSegue(withIdentifier: "LoginToReg", sender: self)
//                            }
//                        }

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
        unRegisterAutoKeyboard()
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

