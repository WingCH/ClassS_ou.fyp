//
//  ClassesTableViewController.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 12/2/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import GoogleSignIn
import SwiftyJSON

class ClassesCell: UITableViewCell{
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    //https://www.jianshu.com/p/01f61359b30d
    //http://blog.csdn.net/json_6/article/details/51890313
    //重寫cell的frame 製造tabel cell 間隔
    override var frame:CGRect{
        didSet {
            var newFrame = frame
            newFrame.origin.y += 10
            newFrame.size.height -= 10
            super.frame = newFrame
        }
    }
}

class Class:NSObject {
    
    let bgUrl:String
    let name:String
    let docID:String
    let classID:String
    let startTime:String
    let endTime:String
    
    init(bgUrl:String, name:String, docID:String,classID:String, startTime:String, endTime:String) {
        self.bgUrl = bgUrl
        self.name = name
        self.docID = docID
        self.classID = classID
        self.startTime = startTime
        self.endTime = endTime
    }
    
}

class ClassesTableViewController: UITableViewController {

    let db = Firestore.firestore()
    var classes:[Class] = []
    var persons:[Person] = []
    //折衷方法
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.collection("class").addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    let data = diff.document
                    if (diff.type == .added) {

                        let json = JSON(arrayLiteral: data.data())
                        print(json)
                        print(json[0]["bgUrl"].string!)
                        print( json[0]["name"].string!)
                        print(json[0]["id"].string!)

                        print(json[0]["dateTime"]["start"].string!)
                        print(json[0]["dateTime"]["end"].string!)


                        let classes = Class(bgUrl: json[0]["bgUrl"].string!, name: json[0]["name"].string!, docID: diff.document.documentID, classID: json[0]["id"].string!, startTime: json[0]["dateTime"]["start"].string!, endTime: json[0]["dateTime"]["end"].string!)
                        self.classes.append(classes)
                        self.tableView.reloadData()
                    }
//                    if (diff.type == .modified) {
//                        print("Modified city: \(diff.document.data())")
//                    }
                    if (diff.type == .removed) {
                        self.classes = self.classes.filter({$0.docID != data.documentID})
                        self.tableView.reloadData()
                    }
                }
        }
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let json = JSON(arrayLiteral: document.data())
                    print(json)
                    
                    for (_,subJson):(String, JSON) in json {
                        self.persons.append(Person(authID: document.documentID, authEmail: subJson["email"].string!, authName: subJson["name"].string!, studentID: subJson["studentID"].string!, personId: subJson["personId"].string!, persistedFaceIds: subJson["persistedFaceIds"].arrayObject as! [String]))
                    }
                }
            }
        }

    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return classes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classesCell", for: indexPath) as! ClassesCell
        
        let url = URL(string: classes[indexPath.row].bgUrl)
        cell.bg.kf.setImage(with: url)
        cell.name.text = classes[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Click \(classes[indexPath.row].name)")
        //pass "data.documentID" to attendance page
        print("pass :\(classes[indexPath.row].docID)")
        self.performSegue(withIdentifier: "classToMain", sender: indexPath.row)
    }

    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            //https://stackoverflow.com/questions/49827821/why-my-google-sign-in-doesnt-show-account-selection-after-i-successfully-sign-i
            GIDSignIn.sharedInstance()?.signOut()
            try firebaseAuth.signOut()
            
            self.performSegue(withIdentifier: "BackToLogin", sender: self)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "classToMain"{
            let tabCtrl: UITabBarController = segue.destination as! UITabBarController
            let destinationVC = tabCtrl.viewControllers![0] as! AttendanceTableViewController
            let row:Int = sender as! Int
            destinationVC.id = classes[row].classID
            destinationVC.persons = persons
            destinationVC.startTime = classes[row].startTime
            destinationVC.endTime = classes[row].endTime
        }

    }


}
