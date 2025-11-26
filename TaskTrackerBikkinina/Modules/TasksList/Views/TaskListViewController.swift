//
//  ViewController.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 19.11.2025.
//

import UIKit
import SnapKit

class TaskListViewController: UIViewController {
    
    private let presenter: TaskListPresenterProtocol
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.text = "Задачи"
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        return titleLabel
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "\(TaskTableViewCell.self)")
        return tableView
    }()
    
    private lazy var bottomLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .bottomGray
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        return titleLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        initializeView()
        setUpConstraints()
        // Do any additional setup after loading the view.
    }

    init(tasksPresenter: TaskListPresenterProtocol) {
        presenter = tasksPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "\(TaskTableViewCell.self)", for: indexPath) as! TaskTableViewCell
        
        taskCell.configure(task: presenter.cellForRowAt(indexPath: indexPath))
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(indexPath: indexPath)
        
    }
}

extension TaskListViewController {
    private func initializeView() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        self.view.addSubview(bottomLabel)
    }
    
    private func setUpConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(110)
            make.left.right.equalToSuperview().inset(20)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.width.bottom.equalToSuperview()
        }
    }
}

extension TaskListViewController: TaskListViewProtocol {
    func getBottomDescription(description: String) {
        self.bottomLabel.text = description
    }
}
