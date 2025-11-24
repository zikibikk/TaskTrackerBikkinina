//
//  TasksListInteractor.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 21.11.2025.
//

import Foundation

class TaskListInteractor {
    
    private let coreDataService = CoreDataService.shared
    static var shared = TaskListInteractor()
}

extension TaskListInteractor: TaskListInteractorProtocol {
    
    func createTask(from task: TaskDTO) {
        coreDataService.createTask(fromTask: task)
    }
    
    func getAllTasks() -> [TaskModel] {
        guard let tasks = coreDataService.fetchAllTasks() else {return []}
        return tasks.map { entity in
            return TaskModel(withEntity: entity)
        }
    }
    
    func getTask(withID id: UUID) -> TaskModel? {
        guard let taskEntity = coreDataService.fetchTask(withID: id) else {return nil}
        return TaskModel(withEntity: taskEntity)
    }
    
    func updateTask(withID id: UUID, newTask: TaskDTO) -> Bool {
        return coreDataService.updateTask(withID: id, newTask: newTask)
    }
}
