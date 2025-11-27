//
//  TaskRouter.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 27.11.2025.
//

import UIKit

final class TaskRouter: TaskRouterProtocol {

    weak var viewController: UIViewController?

    func close() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
