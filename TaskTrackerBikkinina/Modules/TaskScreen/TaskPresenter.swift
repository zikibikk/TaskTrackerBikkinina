//
//  TaskScreenPresenter.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 25.11.2025.
//

class MockTaskPresenter: TaskPresenterProtocol {
    
    weak var view: TaskViewProtocol?
    
    func viewDidLoad() {
        view?.getTitle(taskTitle: "Прибраться в квартире")
        view?.getDate(date: "02/08/2005")
        view?.getText(taskText: "Уборка в квартире это очень долгое занятие, которое выматывает душу и выпивает все соки из молодого тела")
    }
}
