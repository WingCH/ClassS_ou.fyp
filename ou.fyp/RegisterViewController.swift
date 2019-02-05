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

class RegisterViewController: FormViewController {
    
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
            static let studentID = "Student ID"
        }
        
        form +++ Section("Google sigin information")
            <<< TextRow("AccountID") {
                $0.title = FormItems.AccountID
                $0.value = Auth.auth().currentUser?.uid
                $0.disabled = true
            }
            <<< TextRow("Email") {
                $0.title = FormItems.AccountEmail
                $0.value = Auth.auth().currentUser?.email
                $0.disabled = true
            }
            <<< TextRow("UserName") {
                $0.title = FormItems.AccountUserName
                $0.value = Auth.auth().currentUser?.displayName
                $0.disabled = true
        }
        
        form +++ Section("Additional information")
            <<< TextRow("StudentID") {
                $0.cell.textField.keyboardType = .numberPad
                $0.title = FormItems.studentID
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.add(rule: RuleMaxLength(maxLength: 8))
                $0.validationOptions = .validatesOnChange
                }
                .cellUpdate { cell, row in
                    print("cellUpdate")
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
                        let accountID_row: TextRow? = self.form.rowBy(tag: "AccountID")
                        let usersRef =  Firestore.firestore().collection("users").document(accountID_row!.value!)
                        usersRef.updateData([
                            "studentID": row.value!,
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("成功寫入student ID to firestore")
                                row.disabled = true
                                row.evaluateDisabled()
                                self.form.sectionBy(tag: "Face")?.hidden = false
                                self.form.sectionBy(tag: "Face")?.evaluateHidden()
                            }
                        }
                    }
            }
            
            
            +++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                                   header: "Upload your face photo",
                                   footer: "Minimum upload 3 photos") {
                                    $0.tag = "Face"
                                    $0.hidden = true
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Face"
                                            $0.validationOptions = .validatesOnChangeAfterBlurred
                                        }
                                    }
                                    
                                    $0.multivaluedRowToInsertAt = { index in
                                        return ImageRow() {
                                            $0.title = "Face \(index+1)"
                                            $0.sourceTypes = [.PhotoLibrary, .Camera]
                                            $0.clearAction = .yes(style: UIAlertAction.Style.destructive)
                                            $0.validationOptions = .validatesOnChangeAfterBlurred
                                            }
                                            .cellUpdate { cell, row in
//                                                cell.accessoryView?.layer.cornerRadius = 17
//                                                cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                                            }
                                            .onChange{ row in
                                                print("onChange")
                                                let faceImage = row.value!
//                                                row.title = "OK"
                                                
//                                                AzureFaceRecognition.shared.addPersonFace(personId: "af3ca566-60d5-40f4-9edd-6d329eaca443", faceImageData: faceImage.jpegData(compressionQuality: 0.5)!, persistedFaceId: { persistedFaceId in
//                                                    print(persistedFaceId)
//                                                    DispatchQueue.main.async {
//                                                        row.disabled = true
//                                                        row.evaluateDisabled()
//                                                        row.reload()
//                                                    }
//
//                                                })
                                                
                                        }

                                    }
        }
    }
    
    @IBAction func submit(_ sender: UIBarButtonItem) {
        let formData = self.form.values()
        let accountID = formData["AccountID"]
        print(accountID!!)
        
    }
}
