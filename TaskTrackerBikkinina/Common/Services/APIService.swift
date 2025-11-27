//
//  APIService.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 27.11.2025.
//

import Foundation

final class APIService {

    static let shared = APIService()
    private init() {}

    func fetchTasks(completion: @escaping (Result<[TaskDTO], Error>) -> Void) {
        let url = URL(string: "https://dummyjson.com/todos")!

        URLSession.shared.dataTask(with: url) { data, _, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1)))
                return
            }

            do {
                let response = try JSONDecoder().decode(APIResponse.self, from: data)
                let dtos = response.todos.map { $0.toTaskDTO() }
                completion(.success(dtos))

            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
}

// модель для корневого ответа API
struct APIResponse: Decodable {
    let todos: [APITask]
}
