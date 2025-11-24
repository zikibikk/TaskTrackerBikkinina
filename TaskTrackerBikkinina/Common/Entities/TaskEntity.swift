//
//  TaskModel.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 19.11.2025.
//

import Foundation
import CoreData

@objc(TaskEntity)
public class TaskEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var text: String?
    @NSManaged public var date: Date
    @NSManaged public var isDone: Bool
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.id = UUID()
    }
}

extension TaskEntity: Identifiable {}

extension TaskEntity {
    public func getInfo(fromTask task: TaskDTO) {
        self.date = task.date
        self.title = task.title
        self.text = task.text ?? ""
        self.isDone = task.isDone
    }
}


public struct TaskDTO {
    var date: Date
    var title: String
    var text: String?
    var isDone: Bool
    
    init(date: Date, title: String, id: UUID? = nil, text: String? = nil, isDone: Bool) {
        self.date = date
        self.title = title
        self.text = text
        self.isDone = isDone
    }
}

struct TaskModel {
    var id: UUID?
    var date: String
    var title: String
    var text: String?
    var isDone: Bool
    
    init(id: UUID? = nil, date: String, title: String, text: String? = nil, isDone: Bool) {
        self.id = id
        self.date = date
        self.title = title
        self.text = text
        self.isDone = isDone
    }
    
    init(withEntity entity: TaskEntity) {
        self.id = entity.id
        self.date = entity.date.formatted(date: .numeric, time: .shortened)
        self.title = entity.title
        self.text = entity.text
        self.isDone = entity.isDone
    }
}
