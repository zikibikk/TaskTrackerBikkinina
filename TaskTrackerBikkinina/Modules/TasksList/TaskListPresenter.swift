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
    private var filteredTasks: [TaskModel] = []
    private var isFiltering: Bool = false
    
    private let apiLoadedKey = "apiLoaded"

    private var isApiLoaded: Bool {
        UserDefaults.standard.bool(forKey: apiLoadedKey)
    }

    private func setApiLoaded() {
        UserDefaults.standard.set(true, forKey: apiLoadedKey)
    }

    init(view: TaskListViewProtocol,
         interactor: TaskListInteractorProtocol,
         router: TaskListRouterProtocol) {

        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
//MARK: navigation logic
    func didSelectRowAt(indexPath: IndexPath) {
        isFiltering ? router.openTaskDetail(with: filteredTasks[indexPath.row]) : router.openTaskDetail(with: tasks[indexPath.row])
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
        tasks = interactor.getAllTasks()
        if !isApiLoaded {
            interactor.fetchTasksFromAPI { [weak self] models in
                self?.tasks += models
                self?.view?.reloadTable()
                self?.view?.getBottomDescription(description: "\(models.count) задач")
                self?.setApiLoaded()
            }
        } else {
            self.view?.reloadTable()
            self.view?.getBottomDescription(description: "\(tasks.count) задач")
        }
    }
    
    private func reloadTasks() {
        tasks = interactor.getAllTasks()
        view?.reloadTable()
        view?.getBottomDescription(description: "\(tasks.count) задач")
    }
    
//MARK: view controller methods
    func viewDidLoad() {
        loadTasks()
    }
    
    func viewWillAppear() {
        reloadTasks()
    }
    
    func numberOfRowsInSection() -> Int {
        return isFiltering ? filteredTasks.count : tasks.count
    }

    func cellForRowAt(indexPath: IndexPath) -> TaskModel {
        return isFiltering ? filteredTasks[indexPath.row] : tasks[indexPath.row]
    }

    func didTapDelete(_ task: TaskModel) {
        guard let id = task.id else { return }

        interactor.deleteTask(withID: id) {_ in 
            self.reloadTasks()
        }
    }
    
    func didTapStatus(at indexPath: IndexPath) {
        
        if isFiltering {
            var task = filteredTasks[indexPath.row]
            task.isDone.toggle()
            interactor.updateTaskStatus(id: task.id!, isDone: task.isDone) {
                
                self.filteredTasks[indexPath.row] = task
                self.view?.reloadRow(at: indexPath)
            }
        } else {
            var task = tasks[indexPath.row]
            task.isDone.toggle()
            interactor.updateTaskStatus(id: task.id!, isDone: task.isDone) {
                
                self.tasks[indexPath.row] = task
                self.view?.reloadRow(at: indexPath)
            }
        }
    }
    
    func filterTasks(by text: String) {
        if text.isEmpty {
            isFiltering = false
            filteredTasks.removeAll()
        } else {
            isFiltering = true
            filteredTasks = tasks.filter {
                $0.title.lowercased().contains(text.lowercased())
            }
        }

        view?.reloadTable()
        view?.getBottomDescription(description: "\(numberOfRowsInSection()) задач")
    }

}
