//
//  Assembly.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 25.11.2025.
//

import UIKit

import UIKit

enum TaskScreenAssembly {

    static func createMode() -> UIViewController {
        return assemble(mode: .create)
    }

    static func editMode(task: TaskModel) -> UIViewController {
        return assemble(mode: .edit(task))
    }

    private static func assemble(mode: TaskScreenMode) -> UIViewController {

        let view = TaskViewController()
        let interactor = TaskInteractor()
        let router = TaskRouter()

        let presenter = TaskPresenter(
            view: view,
            interactor: interactor,
            router: router,
            mode: mode
        )

        view.presenter = presenter
        router.viewController = view

        return view
    }
}

