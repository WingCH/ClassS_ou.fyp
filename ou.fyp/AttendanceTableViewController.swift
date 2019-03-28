////
////  AttendanceTableViewController.swift
////  ou.fyp
////
////  Created by Chan Hong Wing on 12/2/2019.
////  Copyright © 2019 Chan Hong Wing. All rights reserved.
////
//
//import UIKit
//import Firebase
//import GoogleSignIn
//import SwiftMoment
//import SwiftyJSON
//import Async
//
//
//class StudentCell:UITableViewCell{
//    @IBOutlet weak var faceImage: UIImageView!
//    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var studentID: UILabel!
//    @IBOutlet weak var comment: UILabel!
//    @IBOutlet weak var status: UILabel!
//}
//
//class Student: NSObject {
//    let id:String
//    var attend:[String]=[]
//    var comments:[String]=[]
//    init(id:String) {
//        self.id = id
//
//    }
//    init(id:String, attend:[String], comments:[String]) {
//        self.id = id
//        self.attend = attend
//        self.comments = comments
//    }
//}
//
//class AttendanceTableViewController: UITableViewController {
//
//    var id:String?
//    var startTime:String?
//    var endTime:String?
//
//    var persons:[Person] = []
//    var studentAttend:[Student] = []
//
//    var sortListstudentAttend:[Student] = []
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        print(persons[0].authEmail)
////
////        print(moment())
////        print(moment(Date(timeIntervalSince1970: 1550113200)))
////
////        print(moment(Date(timeIntervalSince1970: 1550120400)))
////
////                print(moment(Date(timeIntervalSince1970: 1550052707.879932)))
//
//
//        let _ =  Firestore.firestore().collection("class").whereField("id", isEqualTo: "COMPS456F").addSnapshotListener({ querySnapshot, error in
//            guard let snapshot = querySnapshot else {
//                print("Error fetching snapshots: \(error!)")
//                return
//            }
//            snapshot.documentChanges.forEach { diff in
//                if (diff.type == .added) {
//                    print("Add")
//                    let json = JSON(arrayLiteral: diff.document.data())
//                    for (_,subJson):(String, JSON) in json[0]["student"] {
//                        let student = Student(id: subJson["id"].string!, attend: subJson["attend"].arrayObject as! [String], comments:subJson["comments"].arrayObject as! [String])
//                        self.studentAttend.append(student)
//                    }
//                    self.tableView.reloadData()
//                }
//                if (diff.type == .modified) {
//                    print("Modified")
//                }
//                if (diff.type == .removed) {
//                    print("Removed")
//                }
//            }
//        })
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//
//        return studentAttend.count
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath) as! StudentCell
//        cell.studentID.text = studentAttend[indexPath.row].id
//        cell.comment.text = studentAttend[indexPath.row].comments.last
//        let startTime = moment(Date(timeIntervalSince1970: Double(self.startTime!)!))
//        let endTime = moment(Date(timeIntervalSince1970: Double(self.endTime!)!))
//
//        let last_attend = moment(Date(timeIntervalSince1970: Double(studentAttend[indexPath.row].attend.first!)!))
//        print(last_attend)
//        if last_attend >= startTime && last_attend <= endTime{
//            cell.status.text = "出席"
//            if last_attend + 30.minutes < moment(){
//                cell.status.text = "走堂ed"
//            }
//        }else{
//            cell.status.text = "缺席"
//        }
//
//
//        if let person = persons.first(where: {$0.studentID == studentAttend[indexPath.row].id}) {
//
//            cell.name.text = person.authName
//        } else {
//            // item could not be found
//            print("item could not be found")
//        }
//
//        return cell
//    }
//
//
//
//
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
