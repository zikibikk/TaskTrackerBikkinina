//
//  Assembly.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 25.11.2025.
//

import UIKit

enum TaskScreenAssembly {
    static func assemble() -> UIViewController {
        let taskPresenter = MockTaskPresenter()
        let taskViewController = TaskViewController(taskPresenter: taskPresenter)
        
        taskPresenter.view = taskViewController
        return taskViewController
    }
}
