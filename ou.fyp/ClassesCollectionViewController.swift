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


class ClassesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var classes:[Class] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ReachabilityManager.shared.addListener(listener: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ReachabilityManager.shared.removeListener(listener: self)
    }
    
    override func viewDidLoad() {
        
        firstnetworkStatus()
        
        FirebaseRealtimeDatabaseRest.shared.getClass(result: {data, error in
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
        self.performSegue(withIdentifier: "classToMain", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "classToMain"{
            let row:Int = sender as! Int
            
            let tabCtrl: UITabBarController = segue.destination as! UITabBarController
            
            let labControllers = tabCtrl.viewControllers![0] as! LabsTableViewController
            labControllers.classId = classes[row].id
            
            let wishTreeControllers = tabCtrl.viewControllers![1] as! WishTreeViewController
            
            wishTreeControllers.classId = classes[row].id
            
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        self.firstnetworkStatus()
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

extension ClassesCollectionViewController: NetworkStatusListener {
    
    func bssidDidChange(bssid: String) {
        print("bssidDidChange")
        print(bssid)
        FirebaseRealtimeDatabaseRest.shared.getWiFiInfoByBSSID(bssId: bssid, result: {data, error in
            guard error == nil else {
                print(error!)
                return
            }
            do{
                let decoder = JSONDecoder()
                let wifiInfo = try decoder.decode(WiFi.self, from: (data!))
                
                DispatchQueue.main.async{
                    self.navigationItem.titleView = self.navTitleWithImageAndText(titleText: wifiInfo.location, imageName: "location")
                }
            }catch let error{
                DispatchQueue.main.async{
                    self.navigationItem.titleView = self.navTitleWithImageAndText(titleText: bssid, imageName: "location")
                }
                print(error)
            }
        })
    }
    
    
    func networkStatusDidChange(status: Reachability.Connection) {
        Loaf("view networkStatusDidChange", state: .error, sender: self).show()
        switch status {
        case .none:
            debugPrint("ClassesCollectionViewController: Network became unreachable")
            self.navigationItem.title = "Please connect OU WiFi"
        case .wifi:
            debugPrint("ClassesCollectionViewController: Network reachable through WiFi")
            break
            
        case .cellular:
            debugPrint("ClassesCollectionViewController: Network reachable through Cellular Data")
            self.navigationItem.title = "Please connect OU WiFi"
        }
    }
    
    //拎當前reachability status
    //因為ReachabilityManager Listener 有更新個陣先會call到networkStatusDidChange
    func firstnetworkStatus() {
        
        guard !NetworkInfos.init().getNetworkInfos().isEmpty else{
            self.navigationItem.titleView = self.navTitleWithImageAndText(titleText: "No BSSID", imageName: "location")
            return
        }
        let bssid = NetworkInfos.init().getNetworkInfos()[0].bssid
        switch ReachabilityManager.shared.reachability.connection {
        case .wifi:
            FirebaseRealtimeDatabaseRest.shared.getWiFiInfoByBSSID(bssId: bssid, result: {data, error in
                guard error == nil else {
                    print(error!)
                    return
                }
                do{
                    let decoder = JSONDecoder()
                    let wifiInfo = try decoder.decode(WiFi.self, from: (data!))
                    
                    DispatchQueue.main.async{
                        self.navigationItem.titleView = self.navTitleWithImageAndText(titleText: wifiInfo.location, imageName: "location")
                    }
                }catch let error{
                    DispatchQueue.main.async{
                        self.navigationItem.titleView = self.navTitleWithImageAndText(titleText: bssid, imageName: "location")
                    }
                    print(error)
                }
            })
        case .cellular:
            self.navigationItem.title = "Please connect OU WiFi"
        case .none:
            self.navigationItem.title = "Please connect OU WiFi"
        }
    }
    
}

extension ClassesCollectionViewController{
    func navTitleWithImageAndText(titleText: String, imageName: String) -> UIView {
        
        // Creates a new UIView
        let titleView = UIView()
        
        // Creates a new text label
        let label = UILabel()
        label.text = titleText
        label.sizeToFit()
        label.center = titleView.center
        label.textAlignment = NSTextAlignment.center
        
        // Creates the image view
        let image = UIImageView()
        image.image = UIImage(named: imageName)
        
        // Maintains the image's aspect ratio:
        let imageAspect = image.image!.size.width / image.image!.size.height
        
        // Sets the image frame so that it's immediately before the text:
        let imageX = label.frame.origin.x - label.frame.size.height * imageAspect
        let imageY = label.frame.origin.y
        
        let imageWidth = label.frame.size.height * imageAspect
        let imageHeight = label.frame.size.height
        
        image.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        
        image.contentMode = UIView.ContentMode.scaleAspectFit
        
        // Adds both the label and image view to the titleView
        titleView.addSubview(label)
        titleView.addSubview(image)
        
        // Sets the titleView frame to fit within the UINavigation Title
        titleView.sizeToFit()
        
        return titleView
        
    }
}

