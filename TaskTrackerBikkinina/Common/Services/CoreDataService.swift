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


//public final class CoreDataService {
//    
//    public static let shared = CoreDataService()
//    
//    private init(){
//        backgroundContext = appDelegate.persistentContainer.newBackgroundContext()
//    }
//    
//    private var appDelegate: AppDelegate {
//        UIApplication.shared.delegate as! AppDelegate
//    }
//    
//    private var context: NSManagedObjectContext {
//        appDelegate.persistentContainer.viewContext
//    }
//    
//    private var backgroundContext: NSManagedObjectContext?
//}
//
//extension CoreDataService {
//    
//    public func createTask(fromTask task: TaskDTO) {
//        
//        guard let backgroundContext = self.backgroundContext else { return }
//        
//        backgroundContext.performAndWait {
//            guard let taskEntityDescription = NSEntityDescription.entity(forEntityName: "\(TaskEntity.self)", in: backgroundContext) else {
//                print("Failed to create taskEntityDescription for \(task) \(TaskEntity.self)")
//                return
//            }
//            
//            let newTaskEntity = TaskEntity(entity: taskEntityDescription, insertInto: self.backgroundContext)
//            
//            newTaskEntity.getInfo(fromTask: task)
//            
//            do {
//                try backgroundContext.save()
//                print("Saved!")
//            } catch {
//                print("Failed to save background context: \(error)")
//            }
//        }
//    }
//    
//    
//    public func fetchAllTasks() -> [TaskEntity]? {
//        guard let backgroundContext = self.backgroundContext else { return [] }
//        
//        return backgroundContext.performAndWait {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(TaskEntity.self)")
//            
//            do {
//                let tasks = try? backgroundContext.fetch(fetchRequest) as? [TaskEntity]
//                return tasks
//            }
//        }
//    }
//    
//    func fetchTask(withID: UUID) -> TaskEntity? {
//        guard let backgroundContext = self.backgroundContext else { return nil }
//        
//        return backgroundContext.performAndWait {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(TaskEntity.self)")
//            let predicate = NSPredicate(format: "id == %@", withID as NSUUID)
//            fetchRequest.predicate = predicate
//            
//            do {
//                let tasks = try? backgroundContext.fetch(fetchRequest) as? [TaskEntity]
//                return tasks?.first
//            }
//        }
//    }
//    
//    public func updateTask(withID: UUID, newTask: TaskDTO) -> Bool {
//        guard let backgroundContext = self.backgroundContext else { return false }
//        guard let fetchedTask = fetchTask(withID: withID) else { return false }
//        
//        fetchedTask.date = newTask.date
//        fetchedTask.isDone = newTask.isDone
//        fetchedTask.text = newTask.text
//        fetchedTask.title = newTask.title
//
//        return backgroundContext.performAndWait {
//            do {
//                try backgroundContext.save()
//                print("Updated")
//                return true
//            } catch {
//                print("Failed to update background context: \(error)")
//                return false
//            }
//        }
//    }
//    
//    public func deleteTask(withID: UUID) -> Bool {
//        guard let backgroundContext = self.backgroundContext else { return false }
//        
//        return backgroundContext.performAndWait {
//            guard let taskToDelete = fetchTask(withID: withID) else { return false }
//            backgroundContext.delete(taskToDelete)
//            do {
//                try backgroundContext.save()
//                print("Deleted")
//                return true
//            } catch {
//                print("Failed to dalete background context: \(error)")
//                return false
//            }
//        }
//    }
//    
//    public func deleteAllTasks() {
//        guard let backgroundContext = self.backgroundContext else { return }
//        
//        backgroundContext.performAndWait {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(TaskEntity.self)")
//            
//            do {
//                let tasks = try? backgroundContext.fetch(fetchRequest) as? [TaskEntity]
//                tasks?.forEach({backgroundContext.delete($0)})
//                try? backgroundContext.save()
//            }
//        }
//    }
//}
