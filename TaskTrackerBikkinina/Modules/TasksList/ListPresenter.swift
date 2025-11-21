//
//  ListPresenter.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 20.11.2025.
//

class MockListPresenter: TaskListPresenterProtocol {
    func numberOfRowsInSection() -> Int {
        10
    }
    
    func cellForRowAt(_ index: Int) -> TaskModel {
        return TaskModel(date: "02/10/24", title: "Уборка в квартире", text: "тщательнейшая уборка в квартире", isDone: true)
    }
    
    
}
