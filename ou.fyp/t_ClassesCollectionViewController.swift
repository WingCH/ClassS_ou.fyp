//
//  ClassesCollectionViewController.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 12/3/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import GoogleSignIn
import SwiftyJSON
import Loaf
import Reachability
import SystemConfiguration.CaptiveNetwork


class t_ClassesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var classes:[Class] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        

        
        FirebaseRealtimeDatabaseRest.shared.getTeacherClass(teacherID: (appDelegate.user?.id)!, result: {data, error in
            for (_, element) in data!.enumerated() {
                print("element")
                print(element)
                do{
                    let decoder = JSONDecoder()
                    let `class` = try decoder.decode(Class.self, from: element.1.rawData())
                    self.classes.append(`class`)
                }catch let error{
                    print(error)
                }
            }
            
             self.classes = self.classes.sorted(by: {$0.id > $1.id})
            DispatchQueue.main.async{
                self.collectionView!.reloadData()
            }
        })
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classes.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ClassesCollectionViewCell
        let url = URL(string: classes[indexPath.row].bgUrl)
        cell.locationImage.kf.setImage(with: url)

        cell.locationName.text = classes[indexPath.row].name
        cell.introduction.text = classes[indexPath.row].introduction
        
        

        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(classes[indexPath.row].name)
        self.performSegue(withIdentifier: "t_classToMain", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "t_classToMain"{
            let row:Int = sender as! Int
            
            let tabCtrl: UITabBarController = segue.destination as! UITabBarController
            
            let destinationVC = tabCtrl.viewControllers![0] as! AttendanceCollectionViewController
            destinationVC.classID = classes[row].id
            destinationVC.duration = classes[row].duration
            
            let labControllers = tabCtrl.viewControllers![1] as! LabsTableViewController
            labControllers.classId = classes[row].id

            
        }
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
}
