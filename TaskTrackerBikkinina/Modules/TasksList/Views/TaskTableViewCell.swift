//
//  TaskTableViewCell.swift
//  TaskTrackerBikkinina
//
//  Created by Alina Bikkinina on 20.11.2025.
//

import UIKit
import SnapKit

class TaskTableViewCell: UITableViewCell {
    
    weak var delegate: TaskTableViewCellDelegate?
    
    private var isDone: Bool?
    
    private lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.textColor = .white
        titleLable.font = .systemFont(ofSize: 18, weight: .medium)
        titleLable.numberOfLines = 1
        titleLable.lineBreakMode = .byTruncatingTail
        return titleLable
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byTruncatingTail
        return descriptionLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = .lightGray
        dateLabel.font = .systemFont(ofSize: 14, weight: .regular)
        return dateLabel
    }()
    
    private let statusView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let circleLayer = CAShapeLayer()
    private let checkmarkLayer = CAShapeLayer()

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
        self.contentView.addSubview(statusView)
        setupStatusLayers()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(statusTapped))
        statusView.isUserInteractionEnabled = true
        statusView.addGestureRecognizer(tap)
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
        
        statusView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalTo(titleLable.snp.centerY)
            make.width.height.equalTo(24)
        }
    }
}

//MARK: initialisation
extension TaskTableViewCell {
    func configure(task: TaskModel) {
        descriptionLabel.text = task.text
        isDone = task.isDone
        dateLabel.text = task.date
        if task.isDone {
            makeTaskCompleted(text: task.title)
        } else {
            makeTaskUncompleted(text: task.title)
        }
        updateStatus(isDone: task.isDone)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLable.text = nil
        titleLable.attributedText = nil
        titleLable.textColor = .white
        
        descriptionLabel.text = nil
        dateLabel.text = nil
        descriptionLabel.textColor = .white
        isDone = false
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
        titleLable.attributedText = NSAttributedString(string: text, attributes: [
            .strikethroughStyle: [],
            .foregroundColor: UIColor.white
        ])
        descriptionLabel.textColor = .white
    }
}

//MARK: status ui

extension TaskTableViewCell {
    
    private func updateStatus(isDone: Bool) {
        checkmarkLayer.isHidden = !isDone
        circleLayer.strokeColor = UIColor.systemYellow.cgColor

        if isDone {
            animateCheckmark()
        }
    }
    
    private func setupStatusLayers() {
        let radius: CGFloat = 10
        let center = CGPoint(x: 12, y: 12)
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi/2,
            endAngle: .pi*1.5,
            clockwise: true
        )

        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor.systemYellow.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 2
        circleLayer.lineCap = .round

        statusView.layer.addSublayer(circleLayer)

        let checkPath = UIBezierPath()
        checkPath.move(to: CGPoint(x: 7, y: 12))
        checkPath.addLine(to: CGPoint(x: 11, y: 16))
        checkPath.addLine(to: CGPoint(x: 17, y: 8))

        checkmarkLayer.path = checkPath.cgPath
        checkmarkLayer.strokeColor = UIColor.systemYellow.cgColor
        checkmarkLayer.lineWidth = 2
        checkmarkLayer.lineCap = .round
        checkmarkLayer.lineJoin = .round
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        checkmarkLayer.isHidden = true   // пока скрыта

        statusView.layer.addSublayer(checkmarkLayer)
    }
    
    private func animateCheckmark() {
        checkmarkLayer.removeAllAnimations()
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        checkmarkLayer.strokeEnd = 1
        checkmarkLayer.add(animation, forKey: "drawCheckmark")
    }
    
    @objc private func statusTapped() {
        delegate?.taskCellDidToggleStatus(self)
    }
}
