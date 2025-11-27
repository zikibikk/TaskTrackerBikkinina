//
//  TaskListAssembly.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 27.11.2025.
//

import UIKit

enum TaskListAssembly {
    static func assemble() -> UIViewController {
        let listVC = TaskListViewController()
        let listInteractor = TaskListInteractor()
        let listRouter = TaskListRouter()
        let taskPresenter = TaskListPresenter(view: listVC, interactor: listInteractor, router: listRouter)
        
        listVC.presenter = taskPresenter
        listRouter.viewController = listVC
        return listVC
    }
}
