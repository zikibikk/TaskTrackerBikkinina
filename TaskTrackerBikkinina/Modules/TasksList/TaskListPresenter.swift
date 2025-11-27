//
//  ListPresenter.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 20.11.2025.
//

import UIKit

final class TaskListPresenter: TaskListPresenterProtocol {

    weak var view: TaskListViewProtocol?
    private let interactor: TaskListInteractorProtocol
    private let router: TaskListRouterProtocol

    private var tasks: [TaskModel] = []

    init(view: TaskListViewProtocol,
         interactor: TaskListInteractorProtocol,
         router: TaskListRouterProtocol) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
//MARK: navigation logic
    func didSelectRowAt(indexPath: IndexPath) {
        router.openTaskDetail(with: tasks[indexPath.row])
    }
    
    func didTapAddTask() {
        router.openCreateTaskScreen()
    }
    
    func didLongTap(_ task: TaskModel) {
        router.presentTaskOptions(task)
    }
    
    func didTapEdit(_ task: TaskModel) {
        router.openEditTask(task: task)
    }

    func didTapShare(_ task: TaskModel) {
        router.shareTask(task)
    }
    
//MARK: data layer
    private func loadTasks() {
        interactor.fetchTasksFromAPI { [weak self] models in
            self?.tasks = models
            self?.view?.reloadTable()
            self?.view?.getBottomDescription(description: "\(models.count) задач")
        }
    }
    
    
//MARK: view controller methods
    func viewDidLoad() {
        loadTasks()
    }
    
    func viewWillAppear() {
        reloadTasks()
    }
    
    private func reloadTasks() {
        tasks = interactor.getAllTasks()
        view?.reloadTable()
        view?.getBottomDescription(description: "\(tasks.count) задач")
    }
    
    func numberOfRowsInSection() -> Int {
        return tasks.count
    }

    func cellForRowAt(indexPath: IndexPath) -> TaskModel {
        return tasks[indexPath.row]
    }

    func didTapDelete(_ task: TaskModel) {
        guard let id = task.id else { return }

        interactor.deleteTask(withID: id) {_ in 
            self.reloadTasks()
        }
    }
    
    func didTapStatus(at indexPath: IndexPath) {
        var task = tasks[indexPath.row]
        task.isDone.toggle()

        interactor.updateTaskStatus(id: task.id!, isDone: task.isDone) {
            self.tasks[indexPath.row] = task
            self.view?.reloadRow(at: indexPath)
        }
    }
}
