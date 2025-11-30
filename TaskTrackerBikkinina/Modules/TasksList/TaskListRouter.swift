//
//  TaskListRouter.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 27.11.2025.
//

import UIKit

final class TaskListRouter: TaskListRouterProtocol {

    weak var viewController: UIViewController?

    func openTaskDetail(with task: TaskModel) {
        let taskVC = TaskScreenAssembly.editMode(task: task)
        viewController?.navigationController?.pushViewController(taskVC, animated: true)
    }
    
    func openCreateTaskScreen() {
        let vc = TaskScreenAssembly.createMode()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentTaskOptions(_ task: TaskModel) {
        let vc = TaskOptionsViewController(task: task)
        
        vc.onEdit = { [weak self] in
            self?.openEditTask(task: task)
        }
        
        vc.onShare = { [weak self] in
            self?.shareTask(task)
        }
        
        vc.onDelete = { [weak self] in
            (self?.viewController as? TaskListViewController)?
                .presenter.didTapDelete(task)
        }
        
        viewController?.present(vc, animated: true)
    }
    
    func openEditTask(task: TaskModel) {
            let vc = TaskScreenAssembly.editMode(task: task)
            viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    
    func shareTask(_ task: TaskModel) {
            let text = "\(task.title)\n\n\(task.text ?? "")"
            let avc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            viewController?.present(avc, animated: true)
        }
}
