//
//  ViewController.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 19.11.2025.
//

import UIKit
import SnapKit
import CoreData

class TaskListViewController: UIViewController {
    
    var presenter: TaskListPresenterProtocol!
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        titleLabel.text = "Задачи"
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        titleLabel.isUserInteractionEnabled = true
        return titleLabel
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Поиск"
        searchBar.delegate = self
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
        tableView.keyboardDismissMode = .onDrag
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
    
    private lazy var addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .systemYellow
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "addTaskButton"
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPress)
        presenter.viewDidLoad()
        initializeView()
        setUpConstraints()
        NotificationCenter.default.addObserver( self, selector: #selector(contextDidSave(_:)), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: initializing view
extension TaskListViewController {
    private func initializeView() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        self.view.addSubview(bottomLabel)
        self.view.addSubview(addTaskButton)
        setupTapOutsideSearchBar()
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
        
        addTaskButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomLabel.snp.centerY)
            make.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupTapOutsideSearchBar() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideTouchBar(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

//MARK: TableView delegates
extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "\(TaskTableViewCell.self)", for: indexPath) as! TaskTableViewCell
        
        taskCell.configure(task: presenter.cellForRowAt(indexPath: indexPath))
        taskCell.delegate = self
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//MARK: TableViewCell delegates
extension TaskListViewController: TaskTableViewCellDelegate {
    func taskCellDidToggleStatus(_ cell: TaskTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didTapStatus(at: indexPath)
    }
}

//MARK: SearchBar delegates
extension TaskListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterTasks(by: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK: TaskListViewProtocol extension
extension TaskListViewController: TaskListViewProtocol {
    func getBottomDescription(description: String) {
        self.bottomLabel.text = description
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


//MARK: @objc-s
extension TaskListViewController {
    
    @objc private func addTaskTapped() {
        presenter.didTapAddTask()
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: tableView)

        guard let indexPath = tableView.indexPathForRow(at: point), gesture.state == .began else { return }

        let task = presenter.cellForRowAt(indexPath: indexPath)
        presenter.didLongTap(task)
    }
    
    @objc private func handleTapOutsideTouchBar(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !searchBar.frame.contains(location) {
            searchBar.resignFirstResponder()
        }
    }
    
    @objc private func contextDidSave(_ notification: Notification) {
        let context = CoreDataService.shared.viewContext

        context.perform { [weak self] in
            context.mergeChanges(fromContextDidSave: notification)
            if notification.userInfo?[NSUpdatedObjectsKey] != nil {
                return
            }
            self?.presenter?.viewWillAppear()
        }
    }
}

