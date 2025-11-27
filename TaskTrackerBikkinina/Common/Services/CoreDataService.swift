//
//  CoreDataService.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 21.11.2025.
//

import UIKit
import CoreData

public final class CoreDataService {
    
    public static let shared = CoreDataService()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskTrackerBikkinina")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved CoreData error: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    private init() {}
}

// MARK: - CRUD operations
extension CoreDataService {

    // MARK: Create
    func createTask(_ dto: TaskDTO, completion: (() -> Void)? = nil) {
        let context = newBackgroundContext()

        context.perform {
            let entity = TaskEntity(context: context)
            entity.getInfo(fromTask: dto)

            do {
                try context.save()
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                print("Failed to save new task:", error)
            }
        }
    }

    // MARK: Fetch All
    func fetchAllTasks() -> [TaskEntity] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()

        do {
            return try viewContext.fetch(request)
        } catch {
            print("Failed to fetch tasks:", error)
            return []
        }
    }

    // MARK: Fetch One
    func fetchTask(id: UUID) -> TaskEntity? {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        request.fetchLimit = 1

        return try? viewContext.fetch(request).first
    }

    // MARK: Update
    func updateTask(id: UUID, with dto: TaskDTO, completion: ((Bool) -> Void)? = nil) {
        guard let task = fetchTask(id: id) else {
            completion?(false)
            return
        }

        task.getInfo(fromTask: dto)

        do {
            try viewContext.save()
            completion?(true)
        } catch {
            print("Failed to update:", error)
            completion?(false)
        }
    }

    // MARK: Delete
    func deleteTask(id: UUID, completion: ((Bool) -> Void)? = nil) {
        guard let task = fetchTask(id: id) else {
            completion?(false)
            return
        }

        viewContext.delete(task)

        do {
            try viewContext.save()
            completion?(true)
        } catch {
            print("Failed to delete:", error)
            completion?(false)
        }
    }
}
