//
//  TaskScreenViewController.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 22.11.2025.
//

import UIKit
import SnapKit

final class TaskViewController: UIViewController {

    var presenter: TaskPresenterProtocol!
    
    private lazy var titleTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.font = .systemFont(ofSize: 28, weight: .bold)
        tv.backgroundColor = .clear
        tv.text = ""
        tv.isScrollEnabled = false
        tv.accessibilityIdentifier = "taskTitleField"
        tv.delegate = self
        return tv
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.isEditable = true
        tv.accessibilityIdentifier = "taskDescriptionView"
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "TaskDetailScreen"

        view.backgroundColor = .black
        setupNavigationBar()
        initializeView()
        setUpConstraints()
        presenter.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        presenter.viewWillDisappear(title: titleTextView.text ?? "", text: textView.text ?? "")
    }

    private func setupNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .systemYellow
    }
}

extension TaskViewController {

    private func initializeView() {
        view.addSubview(titleTextView)
        view.addSubview(dateLabel)
        view.addSubview(textView)
    }

    private func setUpConstraints() {
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(6)
            make.left.equalTo(titleTextView)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.left.right.equalTo(titleTextView)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
}

extension TaskViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let maxCharacters = 60
        let current = textView.text ?? ""
        guard let stringRange = Range(range, in: current) else { return false }
        let updated = current.replacingCharacters(in: stringRange, with: text)

        return updated.count <= maxCharacters
    }
}


extension TaskViewController: TaskViewProtocol {

    func fill(title: String, date: String, text: String?) {
        titleTextView.text = title
        dateLabel.text = date
        textView.text = text
    }

    func setEditable(_ editable: Bool) {
        titleTextView.isEditable = editable
        textView.isEditable = editable
    }
}
