//
//  Protocols.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 20.11.2025.
//

import UIKit

protocol TaskListPresenterProtocol {
    func numberOfRowsInSection() -> Int
    func cellForRowAt(_ index: Int) -> TaskModel
}

protocol TaskListInteractorProtocol {
    func createTask(from: TaskDTO)
    func getAllTasks() -> [TaskModel]
    func getTask(withID id: UUID) -> TaskModel?
    func updateTask(withID id: UUID, newTask: TaskDTO) -> Bool
}
