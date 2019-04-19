//
//  RegisterViewController.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 29/1/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import Firebase
import NVActivityIndicatorView
import FirebaseStorage
import GoogleSignIn
import Loaf

class RegisterViewController: FormViewController,NVActivityIndicatorViewable {
    
    
    //    let person = Person()
    let user = User()
    let authID = (Auth.auth().currentUser?.uid)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show NavigationBar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(RegisterViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        //Error message style
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .right
        }
        
        struct FormItems {
            static let AccountID = "Account ID"
            static let AccountEmail = "Email"
            static let AccountUserName = "User Name"
            static let StudentID = "Student ID"
        }
        
        form +++ Section("Google sigin information")
            <<< TextRow("AccountID") {
                $0.title = FormItems.AccountID
                $0.value = authID
                $0.disabled = true
            }
            <<< TextRow("Email") {
                $0.title = FormItems.AccountEmail
                $0.value = user.email
                $0.disabled = true
            }
            <<< TextRow("UserName") {
                $0.title = FormItems.AccountUserName
                $0.value = user.name
                $0.disabled = true
        }
        
        form +++ Section("Additional information")
            <<< TextRow("StudentID") {
                $0.cell.textField.keyboardType = .numberPad
                $0.title = FormItems.StudentID
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.add(rule: RuleMaxLength(maxLength: 8))
                $0.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    print("onRowValidationChanged")
                    let rowIndex = row.indexPath!.row
                    
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, _) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = "Student ID should be 8 number"
                                $0.cell.height = { 30 }
                            }
                            //https://github.com/xmartlabs/Eureka/issues/1800#issuecomment-478968241
//                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                            let indexPath = row.indexPath!.row + index + 1
                            row.section?.insert(labelRow, at: indexPath)
                        }
                    }else{
                        self.user.id = row.value!
                    }
            }
            
            
            +++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                                   header: "Upload your face photo",
                                   footer: "Minimum upload 3 photos") {
                                    $0.tag = "Face"
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Face"
                                            $0.tag = "btn"
                                        }
                                    }
                                    
                                    
                                    $0.multivaluedRowToInsertAt = { index in
                                        
                                        //                                        let buttonRow  = self.form.rowBy(tag: "btn") as! ButtonRow
                                        //                                        buttonRow.disabled = true
                                        //                                        buttonRow.evaluateDisabled()
                                        //
                                        return ImageRow() {
                                            $0.title = "Face \(index+1)"
                                            $0.sourceTypes = [.PhotoLibrary, .Camera]
                                            $0.clearAction = .yes(style: UIAlertAction.Style.destructive)
                                            //$0.validationOptions = .validatesOnChangeAfterBlurred
                                            }
                                            
                                            .cellUpdate { cell, row in
                                                //                                                cell.accessoryView?.layer.cornerRadius = 17
                                                //                                                cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                                            }
                                            .onChange{ row in
                                                print("onChange")
                                                
                                                guard row.value != nil else{
                                                    return
                                                }
                                                
                                                let faceImage = row.value!
                                                AzureFaceRecognition.shared.faceDetect(faceImageData: faceImage.compressTo(4)!, result: {data, error in
                                                    guard error == nil else {
                                                        print(error!)
                                                        Loaf("\(error.debugDescription)", state: .error, sender: self).show()

                                                        return
                                                    }
                                                    
                                                    guard data!["error"].exists() == false else {
                                                        print(data!["error"])
                                                        DispatchQueue.main.async {
                                                            Loaf(data!["error"]["message"].string!, state: .error, sender: self).show()

                                                            row.value = nil
                                                            row.title = data!["error"]["message"].string
                                                            row.reload()
                                                        }
                                                        return
                                                    }
                                                    
                                                    guard data!.count == 1 else{
                                                        print("圖片有\(data!.count)個人臉，只容許有一張人臉，請重拍")
                                                       
                                                        DispatchQueue.main.async {
                                                             Loaf("圖片有\(data!.count)個人臉，只容許有一張人臉，請重拍", state: .error, sender: self).show()
                                                            row.value = nil
                                                            row.title = "請重拍,圖片有\(data!.count)個人臉，只容許有一張人臉"
                                                            row.reload()
                                                        }
                                                        return
                                                    }
                                                    
                                                    if let _ = data![0]["faceId"].string {
                                                        DispatchQueue.main.async {
                                                            row.title = "Sccuess"
                                                            row.disabled = true
                                                            row.evaluateDisabled()
                                                            row.reload()
                                                        }
                                                    }
                                                })
                                                
                                        }
                                        
                                    }
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        let firebaseAuth = Auth.auth()
        do {
            //https://stackoverflow.com/questions/49827821/why-my-google-sign-in-doesnt-show-account-selection-after-i-successfully-sign-i
            GIDSignIn.sharedInstance()?.signOut()
            try firebaseAuth.signOut()
            _ = navigationController?.popViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func submit(_ sender: UIBarButtonItem) {
        
        sender.isEnabled = false
        
        let activityData =  ActivityData()
        let queue = DispatchQueue(label: "com.ou.fyp.queue", qos: DispatchQoS.userInteractive)
        
        //bug: step2 之後先出現
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        
        // 1. PersonGroup Person - Create   ->  personId
        // 2. PersonGroup Person - Add Face ->  persistedFaceId x3
        // 3. Upload All data to Firestote
        // 4. PersonGroup - Train
        
        let formData = self.form.values()
        var persistedFaceIds_Source:[String:UIImage] = [:]
        print(self.user.id!)
        // 1. PersonGroup Person - Create   ->  personId
        
        let group = DispatchGroup()
        group.enter()
        queue.async {
            AzureFaceRecognition.shared.personCreate(name: self.user.id!, userData: self.authID, result:{ data, error in
                
                guard error == nil else {
                    print(error!)
                    return
                }
                
                guard data!["error"].exists() == false else {
                    print(data!["error"])
                    return
                }
                self.user.personId = data!["personId"].string
                group.leave()
            })
        }
        group.wait()
        
        print("personCreate done")
        
        
        // 2. PersonGroup Person - Add Face ->  persistedFaceId x3
        for (index, faceImageData) in (formData["Face"]!! as! [UIImage]).enumerated(){
            print("第\(index)張相片上傳開始！！")
            group.enter()
            queue.async {
                AzureFaceRecognition.shared.personAddFace(personId: self.user.personId!, faceImageData: faceImageData.compressTo(4)!, result: {data, error in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    
                    guard data!["error"].exists() == false else {
                        print(data!["error"])
                        return
                    }
                    
                    if let faceId = data!["persistedFaceId"].string {
                        print("第\(index)張相上傳成功 :\(faceId)")
                        persistedFaceIds_Source[faceId] = faceImageData
                        group.leave()
                    }
                })
            }
        }
        group.wait()
        print("personAddFace done")
        print(persistedFaceIds_Source)

        UploadImagesToFirestore.saveImages(uid: self.user.id!, persistedFaceIds_Source: persistedFaceIds_Source,result: {uploadedImageUrlsArray in
            print("back here")
            print(uploadedImageUrlsArray)
            
            // 3. Upload All data to Firestote
            //firestore(/users/userid) 未有user 資料
            //init user 寫入user data to firestore
            
            self.user.persistedFaceIds = uploadedImageUrlsArray
            
            FirebaseRealtimeDatabaseRest.shared.putUser(userData: self.user.getData(), result: {data, error in
                print("putUser")
                guard error == nil else {
                    print(error!)
                    return
                }
                
                guard data!["error"].exists() == false else {
                    print(data!["error"])
                    return
                }
                
                print("success")
                
                DispatchQueue.main.async {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
                    self.navigationController?.popViewController(animated: true)
                    
                }
                
            })
            
        })
        
        
    }
    
    
}
