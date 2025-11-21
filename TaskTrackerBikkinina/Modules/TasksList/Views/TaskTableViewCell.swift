//
//  TaskTableViewCell.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 20.11.2025.
//

import UIKit
import SnapKit

class TaskTableViewCell: UITableViewCell {
    
    var title: String? {
        set { titleLable.text = newValue }
        get { return titleLable.text}
    }
    
    var text: String? {
        set { descriptionLabel.text = newValue }
        get { return descriptionLabel.text }
    }
    
    var date: String? {
        set { dateLabel.text = newValue }
        get { return dateLabel.text}
    }
    
    var isDone: Bool?
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.textColor = .white
        titleLable.font = .systemFont(ofSize: 18, weight: .medium)
        return titleLable
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        
        if isDone ?? false {
            descriptionLabel.textColor = .lightGray
        } else {
            descriptionLabel.textColor = .white
        }
        
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

        // Configure the view for the selected state
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
