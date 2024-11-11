//
//  CreateOrEditNoteViewController.swift
//  NotesApp
//
//  Created by Vladislav on 17.10.2022.
//

import UIKit
import FirebaseDatabase

class CreateOrEditNoteViewController: BaseViewController {
    
    var output: CreateOrEditNoteViewOutput!
    
    var state = CreateOrEditeNoteState.edit
    var noteID: String?
    var sectionType: NotesSectionsData.SectionsType = .today
    var onFinish: ((_ id: String, _ sectionType: NotesSectionsData.SectionsType) -> Void)?
    
    private let separator = UIView()
    private let noteTextView = UITextView()
    private let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
}

//MARK: CreateOrEditeNoteViewInput
extension CreateOrEditNoteViewController: CreateOrEditNoteViewInput {

    func popNotesViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setNoteTextView(_ text: String) {
        noteTextView.text = text
    }
    
    func updateID(_ id: String) {
        noteID = id
    }
    
    func onFinished() {
        if let noteID = noteID {
            onFinish?(noteID, sectionType)
        }
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .cancel, handler: { [weak self] (action: UIAlertAction) in
            self?.popNotesViewController()
        }))
        self.present(alert, animated: true)
    }
    
    func showIndicator(_ isActive: Bool) {
        if isActive {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }
    func setSaveButton(_ isActive: Bool) {
        self.navigationItem.rightBarButtonItem?.isEnabled = isActive
    }
}

//MARK: Private CreateOrEditeNoteViewController
extension CreateOrEditNoteViewController {
    override func setupUI() {
        separator.backgroundColor = .black
        
        noteTextView.font = .systemFont(ofSize: 18)
        noteTextView.textAlignment = .left
        noteTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        noteTextView.layer.cornerRadius = 10
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.black.cgColor
        noteTextView.textColor = .black
        noteTextView.backgroundColor = .white
        
        spinner.color = .red
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        title = state == .create ? "Create a note".localized() : "Edit note".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem (title: "Save".localized(),
                                                            style: .done,
                                                            target: nil,
                                                            action: #selector(saveNoteButtonDidTap))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back".localized(),
                                                           style: .done,
                                                           target: nil,
                                                           action: nil)
        noteTextView.textContainer.maximumNumberOfLines = 0
    }
    
    override func addSubview() {
        view.addSubview(separator)
        view.addSubview(noteTextView)
        view.addSubview(spinner)
    }
    
    override func addConstraints() {
        separator.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: nil,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 10, left: 0, bottom: 10, right: 0),
                         size: .init(width: view.frame.width, height: 2))
        noteTextView.anchor(top: separator.bottomAnchor,
                            leading: view.leadingAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 10, left: 28, bottom: 10, right: -28))
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func saveNoteButtonDidTap() {
        
        output.saveNoteButtonDidTap(noteTextView.text)
    }
    
}
