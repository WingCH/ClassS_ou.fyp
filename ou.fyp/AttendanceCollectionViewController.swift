//
//  AttendanceCollectionViewController.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 13/3/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
    
}

extension UICollectionViewCell {
    func enable(on: Bool) {
        for view in contentView.subviews {
            view.isUserInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }
}

private let reuseIdentifier = "Cell"

class AttendanceCollectionViewController: UICollectionViewController {
    
    var classID:String?
    var duration: Duration?
    var allStudents: [User] = []
    var attendStudents:[User]=[]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        FirebaseRealtimeDatabaseRest.shared.getStudentByClassID(classID: classID!, result: {data, error in
//            guard data != nil else {
//                print("no data")
//                return
//            }
//            for (_, element) in data!.enumerated() {
//                print(element)
//                do{
//                    let decoder = JSONDecoder()
//                    let student = try decoder.decode(User.self, from: element.1.rawData())
//                    print(student.name)
//                    self.allStudents.append(student)
//
//                }catch let error{
//                    print(error)
//                }
//            }
//
//            self.allStudents = self.allStudents.sorted(by: {Int($0.studentId!)! < Int($1.studentId!)!})
//
//            DispatchQueue.main.async{
//                self.collectionView!.reloadData()
//            }
//
//        })
        
        FirebaseRealtimeDatabaseRest.shared.getAttenedStudentByClassID(classID: classID!, result: {data, error in
            guard data != nil else {
                print("no data")
                return
            }
            
            //return data: [{全部學生data},{已出席學生data}]
            for (_, element) in (data?[0].enumerated())! {
                print(element)
                do{
                    let decoder = JSONDecoder()
                    let student = try decoder.decode(User.self, from: element.1.rawData())
                    print(student.name)
                    self.allStudents.append(student)
                    
                }catch let error{
                    print(error)
                }
            }
            
            for (_, element) in (data?[1].enumerated())! {
                print(element)
                do{
                    let decoder = JSONDecoder()
                    let student = try decoder.decode(User.self, from: element.1.rawData())
                    print(student.name)
                    self.attendStudents.append(student)
                    
                }catch let error{
                    print(error)
                }
            }
            
            self.allStudents = self.allStudents.sorted(by: {Int($0.studentId!)! < Int($1.studentId!)!})
            self.attendStudents = self.attendStudents.sorted(by: {Int($0.studentId!)! < Int($1.studentId!)!})

            DispatchQueue.main.async{
                self.collectionView!.reloadData()
            }
            print(data!)
        })
        
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return allStudents.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StudentCell
        
        cell.name.text = allStudents[indexPath.row].name
        
        if attendStudents.contains(where: { $0.studentId == allStudents[indexPath.row].studentId }) {
            // found
            cell.enable(on: true)
        } else {
            // not
            cell.enable(on: false)
        }

        cell.photo.setRounded()
        
        //拎第一張做
        let url = URL(string: (allStudents[indexPath.row].persistedFaceIds!.first)!.value)
        cell.photo.kf.setImage(with: url)
        
        return cell
    }
    
}
