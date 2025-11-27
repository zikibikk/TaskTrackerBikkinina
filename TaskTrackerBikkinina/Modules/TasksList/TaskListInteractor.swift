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
    
    func fetchTasksFromAPI(completion: @escaping ([TaskModel]) -> Void) {
        APIService.shared.fetchTasks { [weak self] result in
            switch result {
            case .success(let tasksDTO):
                tasksDTO.forEach { dto in
                    self?.createTask(from: dto)
                }
                
                let models = self?.getAllTasks() ?? []
                DispatchQueue.main.async {
                    completion(models)
                }
                
            case .failure:
                let local = self?.getAllTasks() ?? []
                DispatchQueue.main.async {
                    completion(local)
                }
            }
        }
    }
    
    
    func createTask(from dto: TaskDTO, completion: (() -> Void)? = nil) {
        coreDataService.createTask(dto) {
            completion?()
        }
    }
    
    // MARK: Fetch All
    func getAllTasks() -> [TaskModel] {
        return coreDataService.fetchAllTasks().map { TaskModel(withEntity: $0) }
    }
    
    // MARK: Fetch One
    func getTask(withID id: UUID) -> TaskModel? {
        guard let entity = coreDataService.fetchTask(id: id) else { return nil }
        return TaskModel(withEntity: entity)
    }
    
    // MARK: Update
    func updateTask(withID id: UUID, newTask: TaskDTO, completion: ((Bool) -> Void)? = nil) {
        coreDataService.updateTask(id: id, with: newTask, completion: completion)
    }
    
    // MARK: Delete
    func deleteTask(withID id: UUID, completion: ((Bool) -> Void)? = nil) {
        coreDataService.deleteTask(id: id, completion: completion)
    }
}
