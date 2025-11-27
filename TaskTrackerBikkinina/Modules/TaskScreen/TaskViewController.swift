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

    private lazy var titleLabel: UITextField = {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = .systemFont(ofSize: 28, weight: .bold)
        tf.placeholder = "Название"
        return tf
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
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setupNavigationBar()
        initializeView()
        setUpConstraints()
        presenter.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        presenter.viewWillDisappear(
            title: titleLabel.text ?? "",
            text: textView.text ?? ""
        )
    }

    private func setupNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .systemYellow
    }
}

extension TaskViewController {

    private func initializeView() {
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(textView)
    }

    private func setUpConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.equalTo(titleLabel)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
}

extension TaskViewController: TaskViewProtocol {

    func fill(title: String, date: String, text: String?) {
        titleLabel.text = title
        dateLabel.text = date
        textView.text = text
    }

    func setEditable(_ editable: Bool) {
        titleLabel.isEnabled = editable
        textView.isEditable = editable
    }
}
