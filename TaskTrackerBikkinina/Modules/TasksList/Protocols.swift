//
//  Protocols.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 20.11.2025.
//

import UIKit

protocol TaskListPresenterProtocol {
    func viewDidLoad()
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> TaskModel
    func didSelectRowAt(indexPath: IndexPath)
}

protocol TaskListViewProtocol: UIViewController {
    func getBottomDescription(description: String)
}

protocol TaskListInteractorProtocol {
    func createTask(from: TaskDTO)
    func getAllTasks() -> [TaskModel]
    func getTask(withID id: UUID) -> TaskModel?
    func updateTask(withID id: UUID, newTask: TaskDTO) -> Bool
}
