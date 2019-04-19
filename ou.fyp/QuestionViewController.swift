//
//  ViewController.swift
//  Questionnaire
//
//  Created by Chan Hong Wing on 12/4/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftMoment


class QuestionViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    var state:Float = 0.0
    @IBOutlet weak var questionBox: UILabel!
    
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!

    
    var question:Question?
    var answers:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(question!)
        print((question?.questions.count)!)
        nextQuestion(count: answers.count)
    }
    
    
    @IBAction func answerQuestion(_ sender: UIButton) {

        let anw = sender.titleLabel?.text
        answers.append(anw!)
        nextQuestion(count: answers.count)
    }
    
    func nextQuestion(count:Int) {
        
        //更新Progress Bar
        progressView.setProgress(Float(answers.count) / Float((question?.questions.count)!)+0.01, animated: true)

        if !((question?.questions.count)! == count) {
            questionBox.text = self.question?.questions[count].question
            aButton.setTitle(self.question?.questions[count].answer[0], for: .normal)
            bButton.setTitle(self.question?.questions[count].answer[1], for: .normal)
            cButton.setTitle(self.question?.questions[count].answer[2], for: .normal)
            dButton.setTitle(self.question?.questions[count].answer[3], for: .normal)
            
        }else{
            self.view.isUserInteractionEnabled = false

            let appDelegate = UIApplication.shared.delegate as! AppDelegate

            print(answers)
            print((question?.classId)!)
            print((question?.name)!)
            print((appDelegate.user?.id)!)
            
            FirebaseRealtimeDatabaseRest.shared.pushLabAnwser(classId: (question?.classId)!, labName: (question?.name)!, studentId: (appDelegate.user?.id)!, answer: answers, timestamp:String(Date().toMillis()/1000), result: {data, error in

                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.popViewController(animated: true)
                }
            })

        }
    }
}

//https://freakycoder.com/ios-notes-22-how-to-get-current-time-as-timestamp-fa8a0d422879
extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

