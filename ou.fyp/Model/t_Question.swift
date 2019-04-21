//
//  t_Question.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 21/4/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit

public class t_Question: Codable {
    public let classId, name: String
    public let questions: [t_QuestionElement]
    public let completed: [Completed]
    
    public init(classId: String, name: String, questions: [t_QuestionElement], completed: [Completed]) {
        self.classId = classId
        self.name = name
        self.questions = questions
        self.completed = completed
    }
}

public class Completed: Codable {
    public let answer: [String]
    public let classId, labName, studentId, timestamp: String
    
    public init(answer: [String], classId: String, labName: String, studentId: String, timestamp: String) {
        self.answer = answer
        self.classId = classId
        self.labName = labName
        self.studentId = studentId
        self.timestamp = timestamp
    }
}

public class t_QuestionElement: Codable {
    public let answer: [String]
    public let question: String
    
    public init(answer: [String], question: String) {
        self.answer = answer
        self.question = question
    }
}
