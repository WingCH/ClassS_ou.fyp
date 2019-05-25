//
//  t_PostLabViewController.swift
//  ou.fyp
//
//  Created by CHAN Hong Wing on 25/5/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import Loaf

class t_PostLabViewController: UIViewController {

    @IBOutlet weak var context: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func submit(_ sender: Any) {
        FirebaseRealtimeDatabaseRest.shared.postNewLab(context: context.text, result: {status, error in
            if status! == "ok"{
                DispatchQueue.main.async {
                    Loaf("Success", state: .success, sender: self).show()
                }
            }else{
                DispatchQueue.main.async {
                    Loaf(error.debugDescription, state: .error, sender: self).show()
                }
            }
            
        })
    }
    

}
