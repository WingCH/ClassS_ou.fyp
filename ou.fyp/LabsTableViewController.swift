//
//  LabsTableViewController.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 14/4/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit

class LabCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    
}

class LabsTableViewController: UITableViewController {

    var classId:String = ""
    var labs:[Question] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        labs = []
        
        FirebaseRealtimeDatabaseRest.shared.getLabWithStatus(classId: classId, studentId: (appDelegate.user?.id)!, result: {data, error in
            for (_, element) in data!.enumerated() {
                do{
                    let decoder = JSONDecoder()
                    let lab = try decoder.decode(Question.self, from: element.1.rawData())
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
        
//        FirebaseRealtimeDatabaseRest.shared.getLab(classId:classId, result:{data, error in
//            for (_, element) in data!.enumerated() {
//                do{
//                    let decoder = JSONDecoder()
//                    let lab = try decoder.decode(Question.self, from: element.1.rawData())
//                    self.labs.append(lab)
//                }catch let error{
//                    print(error)
//                }
//            }
//
//            self.labs = self.labs.sorted(by: {$0.name < $1.name})
//
//            DispatchQueue.main.async{
//                self.tableView.reloadData()
//            }
//        })
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LabCell

        cell.name.text = labs[indexPath.row].name
        
        //0代表未做 1代表做左
        if(labs[indexPath.row].status==0){
            cell.status.text = "Not done"
        }else{
            cell.status.text = "done"
            cell.enable(on: false)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goLab", sender: indexPath.row)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as! Int
        let controller = segue.destination as! QuestionViewController
        controller.question = labs[index].self
    }
}

//https://stackoverflow.com/a/33033327/10999568
extension UITableViewCell {
    func enable(on: Bool) {
        self.isUserInteractionEnabled = on
        for view in contentView.subviews {
            view.isUserInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }
}
