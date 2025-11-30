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
    func filterTasks(by text: String)
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> TaskModel
    func didSelectRowAt(indexPath: IndexPath)
    func didTapAddTask()
    func didLongTap(_ task: TaskModel)
    func didTapDelete(_ task: TaskModel)
    func didTapEdit(_ task: TaskModel)
    func didTapShare(_ task: TaskModel)
    func didTapStatus(at indexPath: IndexPath)
}

protocol TaskTableViewCellDelegate: AnyObject {
    func taskCellDidToggleStatus(_ cell: TaskTableViewCell)
}

protocol TaskListViewProtocol: UIViewController {
    func getBottomDescription(description: String)
    func reloadTable()
    func reloadRow(at indexPath: IndexPath)
}

protocol TaskListInteractorProtocol {
    func fetchTasksFromAPI(completion: @escaping ([TaskModel]) -> Void)
    func createTask(from dto: TaskDTO, completion: (() -> Void)?)
    func getAllTasks() -> [TaskModel]
    func getTask(withID id: UUID) -> TaskModel?
    func updateTask(withID id: UUID, newTask: TaskDTO, completion: ((Bool) -> Void)?)
    func deleteTask(withID id: UUID, completion: ((Bool) -> Void)?)
    func updateTaskStatus(id: UUID, isDone: Bool, completion: @escaping () -> Void)
}

protocol TaskListRouterProtocol {
    func openEditTask(task: TaskModel)
    func shareTask(_ task: TaskModel)
    func openTaskDetail(with task: TaskModel)
    func openCreateTaskScreen()
    func presentTaskOptions(_ task: TaskModel)
}
