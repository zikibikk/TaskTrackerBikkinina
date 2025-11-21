//
//  TaskModel.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 19.11.2025.
//

import Foundation

struct TaskModel {
    var date: String
    var title: String
    var text: String?
    var isDone: Bool
    
    init(date: String, title: String, text: String? = nil, isDone: Bool) {
        self.date = date
        self.title = title
        self.text = text
        self.isDone = isDone
    }
}
