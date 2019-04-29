//
//  t_LasbRecordTableViewController.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 21/4/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import SwiftMoment

class t_Record: UITableViewCell {
    
    @IBOutlet weak var studentId: UILabel!
    @IBOutlet weak var time: UILabel!

}

class t_LasbRecordTableViewController: UITableViewController {
    
    var labsRecord:[Completed] = []
    var labsQuestion:[t_QuestionElement] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return labsRecord.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! t_Record
        cell.studentId.text = labsRecord[indexPath.row].studentId
        
        cell.time.text = moment(Int(labsRecord[indexPath.row].timestamp)!*1000).format()
        print( moment(Int(labsRecord[indexPath.row].timestamp)!*1000).format())


        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toLabsAnser", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as! Int
        let controller = segue.destination as! t_LabsStudentAnswerTableViewController
        
        controller.labsQuestion = labsQuestion
        controller.labsAnswer = labsRecord[index].answer

    }

}
