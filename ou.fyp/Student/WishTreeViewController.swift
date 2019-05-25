//
//  WishTreeViewController.swift
//  ou.fyp
//
//  Created by CHAN Hong Wing on 30/4/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import Loaf

class WishTreeViewController: UIViewController {
    
    var classId:String = ""
    @IBOutlet weak var wishText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goWish(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if ((wishText?.text) != "") {
            
            FirebaseRealtimeDatabaseRest.shared.wishTree(studentId: (appDelegate.user?.id)!, context: wishText.text!, classId: classId, result: {response, error in
                DispatchQueue.main.async {
                    Loaf("Wished🎉🎉🎉", state: .success, sender: self).show()
                    self.wishText?.text = ""
                }
            })
        }else{
            DispatchQueue.main.async {
                Loaf("No wish wor ching", state: .error, sender: self).show()
            }
        }
    }
    
    
}
