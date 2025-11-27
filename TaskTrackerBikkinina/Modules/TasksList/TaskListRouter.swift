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
}
