//
//  TaskPresenter.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 25.11.2025.
//

import Foundation
final class TaskPresenter: TaskPresenterProtocol {

    weak var view: TaskViewProtocol?
    private let interactor: TaskInteractorProtocol
    private let router: TaskRouterProtocol
    private let mode: TaskScreenMode
    private var task: TaskModel?

    init(
        view: TaskViewProtocol,
        interactor: TaskInteractorProtocol,
        router: TaskRouterProtocol,
        mode: TaskScreenMode
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.mode = mode
    }

    func viewDidLoad() {
        switch mode {
        case .create:
            view?.setEditable(true)
            view?.fill(title: "", date: Date().formatted(date: .numeric, time: .omitted), text: "")
        case .edit(let task):
            self.task = task
            view?.setEditable(true)
            view?.fill(
                title: task.title,
                date: task.date,
                text: task.text ?? ""
            )
        }
    }

    func viewWillDisappear(title: String, text: String) {

        let isEmpty = title.trimmingCharacters(in: .whitespaces).isEmpty &&
                      text.trimmingCharacters(in: .whitespaces).isEmpty
        
        switch mode {
        case .create:
            if isEmpty {
                return 
            }

            let dto = TaskDTO(
                date: Date(),
                title: title,
                text: text,
                isDone: false
            )
            interactor.createTask(dto) {}

        case .edit(let task):
            guard let id = task.id else { return }

            if isEmpty {
                interactor.deleteTask(id: id) {
                    self.router.close()
                }
                return
            }
            
            if (title == task.title) && (text == task.text) { return }

            let dto = TaskDTO(
                date: Date(),
                title: title,
                text: text,
                isDone: task.isDone
            )

            interactor.updateTask(id: id, dto: dto) { _ in }
        }
    }
}
