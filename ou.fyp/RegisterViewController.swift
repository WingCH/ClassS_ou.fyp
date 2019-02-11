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
import Async
import NVActivityIndicatorView
import FirebaseStorage


class Person {
    
    let authID: String
    let authEmail: String
    let authName: String
    
    var studentID: String?{
        didSet{
            print("set studentID to \(String(describing: studentID!))")
        }
    }
    
    
    var personId: String?
    var persistedFaceIds: [String:String]
    
    
    init() {
        self.authID = (Auth.auth().currentUser?.uid)!
        self.authEmail = (Auth.auth().currentUser?.email)!
        self.authName = (Auth.auth().currentUser?.displayName)!
        self.persistedFaceIds = [:]
    }
    
}

class RegisterViewController: FormViewController,NVActivityIndicatorViewable {
    
    
    let person = Person()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show NavigationBar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
                $0.value = person.authID
                $0.disabled = true
            }
            <<< TextRow("Email") {
                $0.title = FormItems.AccountEmail
                $0.value = person.authEmail
                $0.disabled = true
            }
            <<< TextRow("UserName") {
                $0.title = FormItems.AccountUserName
                $0.value = person.authName
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
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }else{
                        
                        self.person.studentID = row.value!
                        
                        
                        //                            //方便upload相個陣用 懶做法
                        //                            self.personId = data!["personId"].string!
                        //
                        //                            let usersRef =  Firestore.firestore().collection("users").document(accountID_row!.value!)
                        //                            usersRef.updateData([
                        //                                "studentID": row.value!,
                        //                                "personId": data!["personId"].string!
                        //                                ]) { err in
                        //                                    if let err = err {
                        //                                        print("Error writing document: \(err)")
                        //                                    } else {
                        //                                        print("成功寫入student ID to firestore")
                        //                                        row.disabled = true
                        //                                        row.evaluateDisabled()
                        //                                        self.form.sectionBy(tag: "Face")?.hidden = false
                        //                                        self.form.sectionBy(tag: "Face")?.evaluateHidden()
                        //                                    }
                        //                            }
                        
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
                                            //                                            $0.validationOptions = .validatesOnChangeAfterBlurred
                                        }
                                    }
                                    
                                    
                                    $0.multivaluedRowToInsertAt = { index in
                                        
                                        //                                        let buttonRow  = self.form.rowBy(tag: "btn") as! ButtonRow
                                        //                                        buttonRow.disabled = true
                                        //                                        buttonRow.evaluateDisabled()
                                        
                                        return ImageRow() {
                                            $0.title = "Face \(index+1)"
                                            $0.sourceTypes = [.PhotoLibrary, .Camera]
                                            $0.clearAction = .yes(style: UIAlertAction.Style.destructive)
                                            //                                            $0.validationOptions = .validatesOnChangeAfterBlurred
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
                                                AzureFaceRecognition.shared.faceDetect(faceImageData: faceImage.jpegData(compressionQuality: 1)!, result: {data, error in
                                                    guard error == nil else {
                                                        print(error!)
                                                        return
                                                    }
                                                    
                                                    guard data!["error"].exists() == false else {
                                                        print(data!["error"])
                                                        DispatchQueue.main.async {
                                                            row.value = nil
                                                            row.title = data!["error"]["message"].string
                                                            row.reload()
                                                        }
                                                        return
                                                    }
                                                    
                                                    guard data!.count == 1 else{
                                                        print("圖片有\(data!.count)個人臉，只容許有一張人臉，請重拍")
                                                        
                                                        DispatchQueue.main.async {
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
                                                
                                                //                                                AzureFaceRecognition.shared.addPersonFace(personId: "af3ca566-60d5-40f4-9edd-6d329eaca443", faceImageData: faceImage.jpegData(compressionQuality: 0.5)!, persistedFaceId: { persistedFaceId in
                                                //                                                    print(persistedFaceId)
                                                //                                                    DispatchQueue.main.async {
                                                //                                                        row.disabled = true
                                                //                                                        row.evaluateDisabled()
                                                //                                                        row.reload()
                                                //                                                    }
                                                //
                                                //                                                })
                                                //                                            AzureFaceRecognition.shared.personAddFace(personId: self.personId, faceImageData: faceImage.jpegData(compressionQuality: 1)!, result: {data, error in
                                                //                                                    guard error == nil else {
                                                //                                                        print(error!)
                                                //                                                        return
                                                //                                                    }
                                                //
                                                //                                                    guard data!["error"].exists() == false else {
                                                //                                                        print(data!["error"])
                                                //                                                        return
                                                //                                                    }
                                                //                                                    DispatchQueue.main.async {
                                                //                                                        row.disabled = true
                                                //                                                        row.evaluateDisabled()
                                                //                                                        row.reload()
                                                //                                                    }
                                                //                                            })
                                        }
                                        
                                    }
        }
    }
    
    @IBAction func submit(_ sender: UIBarButtonItem) {
        
        // 1. PersonGroup Person - Create   ->  personId
        // 2. PersonGroup Person - Add Face ->  persistedFaceId x3
        // 3. Upload All data to Firestote
        // 4. PersonGroup - Train
        
        let formData = self.form.values()
        
        var persistedFaceIds_Source:[String:UIImage] = [:]
        let group = AsyncGroup()
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            AzureFaceRecognition.shared.personCreate(name: self.person.studentID!, userData: self.person.authID, result:{ data, error in
                
                guard error == nil else {
                    print(error!)
                    return
                }
                
                guard data!["error"].exists() == false else {
                    print(data!["error"])
                    return
                }
                self.person.personId = data!["personId"].string
                group.leave()
            })
        }
        group.wait()
        
        print("personCreate done")
        
        for (index, faceImageData) in (formData["Face"]!! as! [UIImage]).enumerated(){
            print("第\(index)張相片上傳開始！！")
            group.enter()
            DispatchQueue.global(qos: .userInitiated).async {
                AzureFaceRecognition.shared.personAddFace(personId: self.person.personId!, faceImageData: faceImageData.jpegData(compressionQuality: 1)!, result: {data, error in
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
                        self.person.persistedFaceIds["\(faceId)"] = ""
                        group.leave()
                        
                        
                    }
                })
            }
        }
        group.wait()
        print("all done")
        print(persistedFaceIds_Source)
        print(self.person.persistedFaceIds)
        
        
        for (key, value) in persistedFaceIds_Source {
            print("Key: \(key) - Value: \(value)")
                let riversRef = Storage.storage().reference().child("students").child(self.person.studentID!).child("\(key).jpg")
                
                riversRef.putData(value.jpegData(compressionQuality: 1)!, metadata: nil, completion: { metadata, error in
                    print(metadata)
                    print(error)
                    guard metadata != nil else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    riversRef.downloadURL { (url, error) in
                        guard url != nil else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        self.person.persistedFaceIds[key] = "\(url!)"
                        print(self.person.persistedFaceIds)
                    }
                })
        }

        
        //firestore(/users/userid) 未有user 資料
        //init user 寫入user data to firestore
        let usersRef =  Firestore.firestore().collection("users").document(self.person.authID)

            usersRef.setData([
                "email": self.person.authEmail,
                "name": self.person.authName,
                "studentID": self.person.studentID!,
                "personId": self.person.personId!,
                "persistedFaceIds":self.person.persistedFaceIds
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("寫入user data to firestore")
                    self.performSegue(withIdentifier: "RegToMain", sender: self)
                }
            }
    }
}
