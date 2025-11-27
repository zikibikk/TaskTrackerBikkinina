//
//  protocols.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 22.11.2025.
//
import UIKit

enum TaskScreenMode {
    case create
    case edit(TaskModel)
}

protocol TaskPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillDisappear(title: String, text: String)
}

protocol TaskViewProtocol: UIViewController {
    func fill(title: String, date: String, text: String?)
    func setEditable(_ editable: Bool)
}

protocol TaskRouterProtocol: AnyObject {
    func close()
}

protocol TaskInteractorProtocol: AnyObject {
    func createTask(_ dto: TaskDTO, completion: @escaping () -> Void)
    func updateTask(id: UUID, dto: TaskDTO, completion: @escaping (Bool) -> Void)
    func deleteTask(id: UUID, completion: @escaping () -> Void)
}
