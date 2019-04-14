//
//  Question.swift
//  Questionnaire
//
//  Created by Chan Hong Wing on 12/4/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit

import Foundation


public class Question: Codable {
    public let questions: [QuestionElement]
    public let name, classId: String
    
    public init(questions: [QuestionElement], name: String, classId: String) {
        self.questions = questions
        self.name = name
        self.classId = classId
    }
}

public class QuestionElement: Codable {
    public let question: String
    public let answer: [String]
    
    public init(question: String, answer: [String]) {
        self.question = question
        self.answer = answer
    }
}
