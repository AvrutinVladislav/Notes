//
//  NotesTableViewCell.swift
//  NotesApp
//
//  Created by Vladislav on 12.10.2022.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    private let dateLabel = UILabel()
    private let titleLabel = UILabel()
    private let separator = UIView()
    
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
    
}

//MARK: NotesTableViewCell
extension NotesTableViewCell {
    
    func configure(model: NotesCellData, cellsCount: Int) {
        titleLabel.text = model.noteText
        if let sectionType = model.sectionType {
            dateLabel.text = dateToString(date: model.date, type: sectionType)
        }
        if cellsCount >= 2 {
            separator.isHidden = false
        }
    }
    
}

//MARK: Private NotesTableViewCell
private extension NotesTableViewCell {
    
    func setupUI() {
        titleLabel.font = .boldSystemFont(ofSize: 14)
        dateLabel.font = .italicSystemFont(ofSize: 12)        
        separator.backgroundColor = .black
        separator.isHidden = true
    }
    
    func addSubview() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(separator)
    }
    
    func addConstraints() {
        titleLabel.anchor(top: safeAreaLayoutGuide.topAnchor,
                          leading: safeAreaLayoutGuide.leadingAnchor,
                          bottom: nil,
                          trailing: safeAreaLayoutGuide.trailingAnchor ,
                          padding: .init(top: 5, left: 30, bottom: 0, right: -30))
        
        dateLabel.anchor(top: nil,
                         leading: safeAreaLayoutGuide.leadingAnchor,
                         bottom: safeAreaLayoutGuide.bottomAnchor,
                         trailing: nil,
                         padding: .init(top: 0, left: 30, bottom: -5, right: 0))
        
        separator.anchor(top: nil,
                         leading: safeAreaLayoutGuide.leadingAnchor,
                         bottom: safeAreaLayoutGuide.bottomAnchor,
                         trailing: safeAreaLayoutGuide.trailingAnchor,
                         padding: .init(top: 0, left: 30, bottom: 0, right: -30),
                         size: .init(width: 0.0, height: 1.0))
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
            formatter.dateFormat = "d M y"
            dateString = formatter.string(from: date)
            return dateString
        case .year:
            formatter.dateFormat = "d M y"
            dateString = formatter.string(from: date)
            return dateString
        }
    }
    
}
