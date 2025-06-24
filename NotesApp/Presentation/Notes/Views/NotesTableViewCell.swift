//
//  NotesTableViewCell.swift
//  NotesApp
//
//  Created by Vladislav on 12.10.2022.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    var doneButtonTapped: (() -> Void)?
    
    private let containerView = UIView()
    private let dateLabel = UILabel()
    private let titleLabel = UILabel()
    private let doneButton = UIButton()
    private var isDone = false {
        didSet {
            doneButton.setImage(isDone ? UIImage(systemName: "checkmark.circle.fill")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
                                       : UIImage(systemName: "circle")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)),
                                for: .normal)
            doneButton.tintColor = isDone ? .blue : .lightGray
            updateLabel()
        }
    }
    static let identifier = "noteCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addSubview()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isDone = false
        titleLabel.text = ""
        dateLabel.text = ""
    }
    
    func configure(model: NotesCellData, sectionType: NotesSectionsData.SectionsType) {
        titleLabel.text = model.noteText
        dateLabel.text = dateToString(date: model.date, type: sectionType)
        isDone = model.isDone
        selectionStyle = .none
    }
    
}

//MARK: Private NotesTableViewCell
private extension NotesTableViewCell {
    
    func setupUI() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = Colors.cellBorderColor.cgColor
        containerView.backgroundColor = .white
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 0
        
        dateLabel.font = .systemFont(ofSize: 12)

        doneButton.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubview() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(doneButton)
    }
    
    func addConstraints() {
        containerView.anchor(top: contentView.topAnchor,
                             leading: contentView.leadingAnchor,
                             bottom: contentView.bottomAnchor,
                             trailing: contentView.trailingAnchor,
                             padding: .init(top: 5, left: 10, bottom: -5, right: -10))
        
        titleLabel.anchor(top: containerView.topAnchor,
                          leading: containerView.leadingAnchor,
                          bottom: dateLabel.topAnchor,
                          trailing: containerView.trailingAnchor,
                          padding: .init(top: 5, left: 10, bottom: -5, right: -60))
        
        dateLabel.anchor(top: nil,
                         leading: containerView.leadingAnchor,
                         bottom: containerView.bottomAnchor,
                         trailing: containerView.trailingAnchor,
                         padding: .init(top: 0, left: 10, bottom: -5, right: -60))
        
        doneButton.anchor(top: containerView.topAnchor,
                          leading: nil,
                          bottom: containerView.bottomAnchor,
                          trailing: containerView.trailingAnchor,
                          padding: .init(top: 0, left: 0, bottom: 0, right: -10))
        
    }
    
    func dateToString(date: Date, type: NotesSectionsData.SectionsType) -> String {
        let dateString: String
        let formatter = DateFormatter()
        switch type {
        case .today:
            formatter.dateFormat = "HH:mm d MMM y"
            dateString = formatter.string(from: date)
            return dateString
        case .yesterday:
            formatter.dateFormat = "HH:mm d MMM y"
            dateString = formatter.string(from: date)
            return dateString
        case .week:
            formatter.dateFormat = "EEEE d MMM y HH:mm"
            dateString = formatter.string(from: date)
            return dateString
        case .mounth:
            formatter.dateFormat = "d MMM y"
            dateString = formatter.string(from: date)
            return dateString
        case .year:
            formatter.dateFormat = "d MMM y"
            dateString = formatter.string(from: date)
            return dateString
        }
    }
    
    func updateLabel() {
        let strikeAttr: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ]
        let defaultAttr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        titleLabel.attributedText = NSAttributedString(string: titleLabel.text ?? "",
                                                       attributes: isDone ? strikeAttr : defaultAttr)
    }
    
    @objc func doneButtonDidTap() {
        isDone.toggle()
        doneButtonTapped?()
    }
    
}
