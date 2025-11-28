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

    // MARK: - Persistent Container
    internal lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskTrackerBikkinina")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved CoreData error: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

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


// MARK: - CRUD Operations
extension CoreDataService {

    // MARK: Create
    func createTask(_ dto: TaskDTO, completion: (() -> Void)? = nil) {
        let context = newBackgroundContext()
        context.perform {
            let entity = TaskEntity(context: context)
            entity.getInfo(fromTask: dto)

            do {
                try context.save()
                DispatchQueue.main.async { completion?() }
            } catch {
                print("Failed to save new task:", error)
            }
        }
    }

    // MARK: Fetch All (UI-safe)
    func fetchAllTasks() -> [TaskEntity] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(key: "date", ascending: false)
            ]

            return (try? viewContext.fetch(request)) ?? []
    }

    // MARK: Fetch One (UI-safe)
    func fetchTask(id: UUID) -> TaskEntity? {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        request.fetchLimit = 1
        return try? viewContext.fetch(request).first
    }

    // MARK: Update Full Task (background)
    func updateTask(id: UUID, with dto: TaskDTO, completion: ((Bool) -> Void)? = nil) {
        let context = newBackgroundContext()

        context.perform {
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as NSUUID)
            request.fetchLimit = 1

            guard let task = try? context.fetch(request).first else {
                DispatchQueue.main.async { completion?(false) }
                return
            }

            task.getInfo(fromTask: dto)

            do {
                try context.save()
                DispatchQueue.main.async { completion?(true) }
            } catch {
                print("Failed to update:", error)
                DispatchQueue.main.async { completion?(false) }
            }
        }
    }

    // MARK: Update Only Status (background)
    func updateTaskStatus(id: UUID, isDone: Bool, completion: @escaping (Bool) -> Void) {

        let context = newBackgroundContext()
        context.perform {
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1

            guard let entity = try? context.fetch(request).first else {
                DispatchQueue.main.async { completion(false) }
                return
            }

            entity.isDone = isDone

            do {
                try context.save()
                DispatchQueue.main.async { completion(true) }
            } catch {
                print("Failed to update:", error)
                DispatchQueue.main.async { completion(false) }
            }
        }
    }

    // MARK: Delete (background)
    func deleteTask(id: UUID, completion: ((Bool) -> Void)? = nil) {
        let context = newBackgroundContext()

        context.perform {
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1

            guard let task = try? context.fetch(request).first else {
                DispatchQueue.main.async { completion?(false) }
                return
            }

            context.delete(task)

            do {
                try context.save()
                DispatchQueue.main.async { completion?(true) }
            } catch {
                print("Failed to delete:", error)
                DispatchQueue.main.async { completion?(false) }
            }
        }
    }
}
