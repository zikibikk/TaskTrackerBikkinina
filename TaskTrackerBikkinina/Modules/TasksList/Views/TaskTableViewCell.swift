//
//  TaskTableViewCell.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 20.11.2025.
//

import UIKit
import SnapKit

class TaskTableViewCell: UITableViewCell {
    
    private var isDone: Bool?
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.textColor = .white
        titleLable.font = .systemFont(ofSize: 18, weight: .medium)
        return titleLable
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return descriptionLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = .lightGray
        dateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return dateLabel
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TaskTableViewCell {
    
    private func initialize() {
        self.contentView.backgroundColor = .black
        self.contentView.addSubview(titleLable)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(dateLabel)
    }
    
    private func setUp() {
        titleLable.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(52)
            make.right.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(6)
            make.left.equalTo(titleLable.snp.left)
            make.right.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(6)
            make.left.equalTo(titleLable.snp.left)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}

extension TaskTableViewCell {
    func configure(task: TaskModel) {
        descriptionLabel.text = task.text
        isDone = task.isDone
        dateLabel.text = task.date
        if task.isDone {
            makeTaskCompleted(text: task.title)
        } else {
            titleLable.text = task.title
        }
    }
    
    func makeTaskCompleted(text: String) {
        descriptionLabel.textColor = .lightGray
        let attributed = NSAttributedString(
            string: text,
            attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.lightGray
            ]
        )
        titleLable.attributedText = attributed
    }
    
    func makeTaskUncompleted(text: String) {
        descriptionLabel.textColor = .white
        titleLable.text = text
        titleLable.textColor = .white
    }
}
