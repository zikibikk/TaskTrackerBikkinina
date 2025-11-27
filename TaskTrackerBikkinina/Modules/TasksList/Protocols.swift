//
//  Protocols.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 20.11.2025.
//

import UIKit

protocol TaskListPresenterProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> TaskModel
    func didSelectRowAt(indexPath: IndexPath)
    func didTapAddTask()
}

protocol TaskListViewProtocol: UIViewController {
    func getBottomDescription(description: String)
    func reloadTable()
}

protocol TaskListInteractorProtocol {
    func fetchTasksFromAPI(completion: @escaping ([TaskModel]) -> Void)
    func createTask(from dto: TaskDTO, completion: (() -> Void)?)
    func getAllTasks() -> [TaskModel]
    func getTask(withID id: UUID) -> TaskModel?
    func updateTask(withID id: UUID, newTask: TaskDTO, completion: ((Bool) -> Void)?)
    func deleteTask(withID id: UUID, completion: ((Bool) -> Void)?)
}

protocol TaskListRouterProtocol {
    func openTaskDetail(with task: TaskModel)
    func openCreateTaskScreen()
}
