//
//  TaskInteractor.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 27.11.2025.
//

import Foundation


final class TaskInteractor: TaskInteractorProtocol {

    private let coreData = CoreDataService.shared

    func createTask(_ dto: TaskDTO, completion: @escaping () -> Void) {
        coreData.createTask(dto) {
            completion()
        }
    }

    func updateTask(id: UUID, dto: TaskDTO, completion: @escaping (Bool) -> Void) {
        coreData.updateTask(id: id, with: dto) { success in
            completion(success)
        }
    }

    func deleteTask(id: UUID, completion: @escaping () -> Void) {
        coreData.deleteTask(id: id)
        completion()
    }
}
