//
//  protocols.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 22.11.2025.
//
import UIKit


protocol TaskPresenterProtocol {
    func viewDidLoad()
}

protocol TaskViewProtocol: UIViewController {
    func getTitle(taskTitle title: String)
    func getDate(date: String)
    func getText(taskText text: String)
}
