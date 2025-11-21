//
//  Protocols.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 20.11.2025.
//

import UIKit

protocol TaskListPresenterProtocol {
    func numberOfRowsInSection() -> Int
    func cellForRowAt(_ index: Int) -> TaskModel
}

protocol TaskTableViewCellProtocol {
    func setUp(task: TaskModel)
}
