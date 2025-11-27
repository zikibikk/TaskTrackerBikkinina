//
//  TaskOptionsViewController.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 27.11.2025.
//

import UIKit
import SnapKit

final class TaskOptionsViewController: UIViewController {

    private let task: TaskModel
    var onEdit: (() -> Void)?
    var onShare: (() -> Void)?
    var onDelete: (() -> Void)?

    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialDark))

    private let container = UIView()
    private let titleLabel = UILabel()
    private let textLabelView = UILabel()
    private let dateLabel = UILabel()

    private let editButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)

    init(task: TaskModel) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLayout()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true)
    }

    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(blurView)
        blurView.frame = view.bounds

        container.backgroundColor = UIColor(white: 0.15, alpha: 1)
        container.layer.cornerRadius = 16
        view.addSubview(container)

        titleLabel.text = task.title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)

        textLabelView.text = task.text
        textLabelView.textColor = .lightGray
        textLabelView.numberOfLines = 3

        dateLabel.text = task.date
        dateLabel.textColor = .gray
        dateLabel.font = .systemFont(ofSize: 12)

        [titleLabel, textLabelView, dateLabel].forEach { container.addSubview($0) }

        configure(button: editButton, title: "Редактировать", image: "square.and.pencil")
        configure(button: shareButton, title: "Поделиться", image: "square.and.arrow.up")
        configure(button: deleteButton, title: "Удалить", image: "trash", red: true)

        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }

    private func configure(button: UIButton, title: String, image: String, red: Bool = false) {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = UIImage(systemName: image)
        config.baseForegroundColor = red ? .systemRed : .white
        config.imagePadding = 12
        config.contentInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
        button.configuration = config
        view.addSubview(button)
    }

    private func setupLayout() {
        container.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.left.right.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(container).offset(16)
            make.left.right.equalTo(container).inset(16)
        }

        textLabelView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalTo(titleLabel)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabelView.snp.bottom).offset(12)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(container).inset(16)
        }

        editButton.snp.makeConstraints { make in
            make.top.equalTo(container.snp.bottom).offset(16)
            make.left.right.equalTo(container)
        }

        shareButton.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom).offset(8)
            make.left.right.equalTo(editButton)
        }

        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(shareButton.snp.bottom).offset(8)
            make.left.right.equalTo(shareButton)
        }
    }

    @objc private func editTapped() {
        dismiss(animated: true) { self.onEdit?() }
    }

    @objc private func shareTapped() {
        dismiss(animated: true) { self.onShare?() }
    }

    @objc private func deleteTapped() {
        dismiss(animated: true) { self.onDelete?() }
    }
}
