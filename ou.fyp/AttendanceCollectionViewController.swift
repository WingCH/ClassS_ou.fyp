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
    var students: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseRealtimeDatabaseRest.shared.getStudentByClassID(classID: classID!, result: {data, error in
            guard data != nil else {
                print("no data")
                return
            }
            for (_, element) in data!.enumerated() {
                print(element)
                do{
                    let decoder = JSONDecoder()
                    let student = try decoder.decode(User.self, from: element.1.rawData())
                    print(student.name)
                    self.students.append(student)
                    
                }catch let error{
                    print(error)
                }
            }
            self.students = self.students.sorted(by: {Int($0.studentId!)! < Int($1.studentId!)!})
            
            DispatchQueue.main.async{
                self.collectionView!.reloadData()
            }
            
        })
        
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return students.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StudentCell
        
        cell.name.text = students[indexPath.row].name
        
        if(students[indexPath.row].studentId == "12017730"){
            cell.enable(on: false)
        }

        cell.photo.setRounded()
        //拎第一張做
        let url = URL(string: (students[indexPath.row].persistedFaceIds!.first)!.value)
        cell.photo.kf.setImage(with: url)
        
        
        // Configure the cell
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
