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
    
    private init(){
        backgroundContext = appDelegate.persistentContainer.newBackgroundContext()
    }
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    private var backgroundContext: NSManagedObjectContext?
}

extension CoreDataService {
    
    public func createTask(fromTask task: TaskDTO) {
        
        guard let backgroundContext = self.backgroundContext else { return }
        
        backgroundContext.performAndWait {
            guard let taskEntityDescription = NSEntityDescription.entity(forEntityName: "\(TaskEntity.self)", in: backgroundContext) else {
                print("Failed to create taskEntityDescription for \(task) \(TaskEntity.self)")
                return
            }
            
            let newTaskEntity = TaskEntity(entity: taskEntityDescription, insertInto: self.backgroundContext)
            
            newTaskEntity.getInfo(fromTask: task)
            
            do {
                try backgroundContext.save()
                print("Saved!")
            } catch {
                print("Failed to save background context: \(error)")
            }
        }
    }
    
    
    public func fetchAllTasks() -> [TaskEntity]? {
        guard let backgroundContext = self.backgroundContext else { return [] }
        
        return backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(TaskEntity.self)")
            
            do {
                let tasks = try? backgroundContext.fetch(fetchRequest) as? [TaskEntity]
                return tasks
            }
        }
    }
    
    func fetchTask(withID: UUID) -> TaskEntity? {
        guard let backgroundContext = self.backgroundContext else { return nil }
        
        return backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(TaskEntity.self)")
            let predicate = NSPredicate(format: "id == %@", withID as NSUUID)
            fetchRequest.predicate = predicate
            
            do {
                let tasks = try? backgroundContext.fetch(fetchRequest) as? [TaskEntity]
                return tasks?.first
            }
        }
    }
    
    public func updateTask(withID: UUID, newTask: TaskDTO) -> Bool {
        guard let backgroundContext = self.backgroundContext else { return false }
        guard let fetchedTask = fetchTask(withID: withID) else { return false }
        
        fetchedTask.date = newTask.date
        fetchedTask.isDone = newTask.isDone
        fetchedTask.text = newTask.text
        fetchedTask.title = newTask.title

        return backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
                print("Updated")
                return true
            } catch {
                print("Failed to update background context: \(error)")
                return false
            }
        }
    }
    
    public func deleteTask(withID: UUID) -> Bool {
        guard let backgroundContext = self.backgroundContext else { return false }
        
        return backgroundContext.performAndWait {
            guard let taskToDelete = fetchTask(withID: withID) else { return false }
            backgroundContext.delete(taskToDelete)
            do {
                try backgroundContext.save()
                print("Deleted")
                return true
            } catch {
                print("Failed to dalete background context: \(error)")
                return false
            }
        }
    }
    
    public func deleteAllTasks() {
        guard let backgroundContext = self.backgroundContext else { return }
        
        backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(TaskEntity.self)")
            
            do {
                let tasks = try? backgroundContext.fetch(fetchRequest) as? [TaskEntity]
                tasks?.forEach({backgroundContext.delete($0)})
                try? backgroundContext.save()
            }
        }
    }
}
