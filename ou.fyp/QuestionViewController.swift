//
//  ViewController.swift
//  Questionnaire
//
//  Created by Chan Hong Wing on 12/4/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit
import SwiftyJSON

class QuestionViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    var state:Float = 0.0
    @IBOutlet weak var questionBox: UILabel!
    
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
    
/**
    {
        "-LZJMSCi1d3ImHH4toWdsfjsfh": {
            "questions": [
            {
            "question": "At what time of life does Erikson stage Industry vs. Inferiority occur?",
            "answer": [
            "old age",
            "adolescence",
            "infancy",
            "school age"
            ]
            },
            {
            "question": "A relationship based on a previous friendship that developed into lovers is characteristic of what love style?",
            "answer": ["Agape", "Storge", "Ludus", "Pragma"]
            },
            {
            "question": "Which love style does this example fir? I try to keep lover a little uncertain about my commitment to him/her",
            "answer": ["Pragma", "Agape", "Storge", "Ludus"]
            }
            ],
            "name": "Lab 1",
            "classId": "COMPS456F"
        }
    }
**/
    
    //https://codebeautify.org/json-escape-unescape
    let data = "{\n  \"-LZJMSCi1d3ImHH4toWdsfjsfh\": {\n    \"questions\": [\n      {\n        \"question\": \"At what time of life does Erikson stage Industry vs. Inferiority occur?\",\n        \"answer\": [\n          \"old age\",\n          \"adolescence\",\n          \"infancy\",\n          \"school age\"\n        ]\n      },\n      {\n        \"question\": \"A relationship based on a previous friendship that developed into lovers is characteristic of what love style?\",\n        \"answer\": [\"Agape\", \"Storge\", \"Ludus\", \"Pragma\"]\n      },\n      {\n        \"question\": \"Which love style does this example fir? I try to keep lover a little uncertain about my commitment to him/her\",\n        \"answer\": [\"Pragma\", \"Agape\", \"Storge\", \"Ludus\"]\n      }\n    ],\n    \"name\": \"Lab 1\",\n    \"classId\": \"COMPS456F\"\n  }\n}"
    
    var question:Question?
    var answers:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        if let dataFromString = data.data(using: .utf8, allowLossyConversion: false) {
            do{
                let json = try JSON(data: dataFromString)
                
                let decoder = JSONDecoder()
                question = try decoder.decode(Question.self, from: json.first!.1.rawData())
                
            }catch let error{
                print(error)
            }
        }
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
            print(answers)
            print("答完")
        }


    }
    
    
}

