final class TaskInteractor: TaskInteractorProtocol {

    private let coreData = CoreDataService.shared

    func createTask(_ dto: TaskDTO, completion: @escaping () -> Void) {
        coreData.createTask(dto) {
            completion()
        }
    }

    func updateTask(id: UUID, dto: TaskDTO, completion: @escaping (Bool) -> Void) {
        coreData.updateTask(withID: id, newTask: dto) { success in
            completion(success)
        }
    }

    func deleteTask(id: UUID, completion: @escaping () -> Void) {
        coreData.deleteTask(withID: id) { _ in
            completion()
        }
    }
}
