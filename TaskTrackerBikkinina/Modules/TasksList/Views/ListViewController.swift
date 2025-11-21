//
//  ViewController.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 19.11.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.layer.cornerRadius = 30
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

