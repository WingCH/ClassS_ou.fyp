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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide NavigationBar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            print(auth)
            if let user = user {
                print("✉️: ", user.email!, "is logined")
                print(user.uid)
                FirebaseRealtimeDatabaseRest.shared.getUser(authId: user.uid, result: {data, error in
                    // 因為user第一次sigin 正常係無資料，所以呢到唔洗handle住
                    //                    guard error == nil else {
                    //                        print(error!)
                    //                        return
                    //                    }
                    //                    guard data!["error"].exists() == false else {
                    //                        print(data!["error"])
                    //                        return
                    //                    }
                    DispatchQueue.main.async {
                        if (data!.isEmpty){
                            self.performSegue(withIdentifier: "LoginToReg", sender: self)
                        }else{
                            print("login")
                            //                            print(data!.dictionaryValue.first!.value.rawData())
                            do{
                                
                                let decoder = JSONDecoder()
                                
                                self.appDelegate.user = try decoder.decode(User.self, from: data!.dictionaryValue.first!.value.rawData())
                                
                                
                            }catch let error{
                                print(error)
                            }
                            
                            
                            switch self.appDelegate.user?.role!{
                                
                            case "student":
                                print("student")
                                self.performSegue(withIdentifier: "LoginToStudent", sender: self)
                            case "teacher":
                                print("teacher")
                                self.performSegue(withIdentifier: "LoginToTeacher", sender: self)
                            case .none:
                                break
                            case .some(_):
                                break
                            }
                            
                        }
                    }
                })
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

