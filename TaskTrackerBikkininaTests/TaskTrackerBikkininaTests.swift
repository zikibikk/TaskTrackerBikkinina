//
//  TaskTrackerBikkininaTests.swift
//  TaskTrackerBikkininaTests
//
//  Created by Alina Bikkinina on 19.11.2025.
//

import Testing
@testable import TaskTrackerBikkinina
import CoreData

// MARK: - Helper
extension CoreDataService {
    func clearAllSynchronously() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        let delete = NSBatchDeleteRequest(fetchRequest: fetch)
        _ = try? viewContext.execute(delete)
    }
}

@Suite(.serialized)
struct TaskTrackerBikkininaTests {

    @MainActor
    @Test
    func testCoreDataCreateTask() async throws {

        CoreDataService.shared.clearAllSynchronously()

        let dto = TaskDTO (
            date: Date(),
            title: "Тестовая задача",
            text: "Описание",
            isDone: false
        )

        // Ждём completion CoreData createTask через continuation
        try await withCheckedThrowingContinuation { continuation in

            CoreDataService.shared.createTask(dto) {
                continuation.resume()
            }
        }

        let tasks = CoreDataService.shared.fetchAllTasks()

        #expect(tasks.count == 1)
        #expect(tasks.first?.title == "Тестовая задача")
    }

    @MainActor
    @Test
    func testCoreDataUpdateStatus() async throws {

        CoreDataService.shared.clearAllSynchronously()

        let dto = TaskDTO(
            date: Date(),
            title: "Update Test",
            text: "Test",
            isDone: false
        )

        // создаём
        try await withCheckedThrowingContinuation { continuation in
            CoreDataService.shared.createTask(dto) {
                continuation.resume()
            }
        }

        let created = CoreDataService.shared.fetchAllTasks().first!
        let id = created.id

        // обновляем статус
        try await withCheckedThrowingContinuation { continuation in
            CoreDataService.shared.updateTaskStatus(id: id, isDone: true) { _ in
                continuation.resume()
            }
        }

        let updated = CoreDataService.shared.fetchAllTasks().first
        #expect(updated?.isDone == true)
    }

    @MainActor
    @Test
    func testInteractorCreateAndFetch() async throws {

        CoreDataService.shared.clearAllSynchronously()
        let interactor = TaskListInteractor.shared
        
        let dto = TaskDTO(
            date: Date(),
            title: "Создание через Interactor",
            text: "Описание",
            isDone: false
        )

        // Ждём completion interactor.createTask
        try await withCheckedThrowingContinuation { continuation in
            interactor.createTask(from: dto) {
                continuation.resume()
            }
        }

        let tasks = interactor.getAllTasks()
        #expect(tasks.count == 1)
        #expect(tasks.first?.title == "Создание через Interactor")
    }

    @MainActor
    @Test
    func testInteractorUpdate() async throws {

        CoreDataService.shared.clearAllSynchronously()
        let interactor = TaskListInteractor.shared
        
        let dto = TaskDTO(
            date: Date(),
            title: "Старый",
            text: "Описание",
            isDone: false
        )
        
        // создаём
        try await withCheckedThrowingContinuation { continuation in
            interactor.createTask(from: dto) { continuation.resume()}
        }
        
        let id = interactor.getAllTasks()[0].id

        let updatedDTO = TaskDTO(
            date: Date(),
            title: "Новый",
            text: "Новое описание",
            isDone: false
        )

        // обновляем
        try await withCheckedThrowingContinuation { continuation in
            interactor.updateTask(withID: id!, newTask: updatedDTO) { _ in
                continuation.resume()
            }
        }

        let tasks = interactor.getAllTasks()
        #expect(tasks.first?.title == "Новый")
    }
}
