//
//  TaskScreenViewController.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 22.11.2025.
//

import UIKit
import SnapKit

class TaskViewController: UIViewController {
    
    private let presenter: TaskPresenterProtocol

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 36, weight: .bold)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = .lightGray
        dateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return dateLabel
    }()
    
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tv.textColor = .white
        tv.textAlignment = .left
        tv.keyboardType = .default
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.isEditable = true
        tv.isScrollEnabled = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        initializeView()
        setUpConstraints()
    }

    init(taskPresenter: TaskPresenterProtocol) {
        presenter = taskPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TaskViewController {
    private func initializeView() {
        self.view.backgroundColor = .black
        self.view.addSubview(titleLabel)
        self.view.addSubview(dateLabel)
        self.view.addSubview(textView)
    }
    
    private func setUpConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.right.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.left.right.equalTo(titleLabel)
        }
    }
}

extension TaskViewController: TaskViewProtocol {
    func getTitle(taskTitle title: String) {
        titleLabel.text = title
    }
    
    func getDate(date: String) {
        dateLabel.text = date
    }
    
    func getText(taskText text: String) {
        textView.text = text
    }
}
