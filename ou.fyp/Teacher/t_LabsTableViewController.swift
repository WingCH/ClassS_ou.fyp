//
//  LabsTableViewController.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 14/4/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import Loaf

class t_LabCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    
    
}

class t_LabsTableViewController: UITableViewController {
    
    var classes:Class?
    var labs:[t_Question] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItems = [add]
        
        labs = []
        
        FirebaseRealtimeDatabaseRest.shared.t_getLabWithCompletedStudent(classId: classes!.id, result: {data, error in
            
            guard error == nil else {
                print(error!)
                DispatchQueue.main.async {
                    Loaf("Error!!! try again", state: .error, sender: self).show()
                }
                return
            }
            
            for (_, element) in data!.enumerated() {
                do{
                    let decoder = JSONDecoder()
                    let lab = try decoder.decode(t_Question.self, from: element.1.rawData())
                    self.labs.append(lab)
                }catch let error{
                    print(error)
                }
            }
            
            self.labs = self.labs.sorted(by: {$0.name < $1.name})
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")


        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return labs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! t_LabCell
        
        cell.name.text = labs[indexPath.row].name
        
        cell.status.text = String(labs[indexPath.row].completed.count)+"/ \(String(describing: (classes?.students.count)!))"
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toLabsRecord", sender: indexPath.row)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLabsRecord"{
            let index = sender as! Int
            let controller = segue.destination as! t_LasbRecordTableViewController
            controller.labsRecord = labs[index].completed
            controller.labsQuestion = labs[index].questions
        }

    }
}
