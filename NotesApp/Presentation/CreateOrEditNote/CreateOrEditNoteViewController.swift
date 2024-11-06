//
//  CreateOrEditNoteViewController.swift
//  NotesApp
//
//  Created by Vladislav on 17.10.2022.
//

import UIKit
import FirebaseDatabase

class CreateOrEditNoteViewController: UIViewController {
    
    //MARK: Public properties
    
    var state = CreateOrEditNotePresentor.CreateOrEditeNoteState.edit
    var noteID: String?
    var sectionType: NotesSectionsData.SectionsType = .today
    var onFinish: ((_ id: String, _ sectionType: NotesSectionsData.SectionsType) -> Void)?
    
    //MARK: Outlets
    
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: UI
    
    private lazy var output: CreateOrEditNoteViewOutput? = {
        
        var presenter = CreateOrEditNotePresentor()
        presenter.state = state
        presenter.noteID = noteID
        presenter.view = self
        return presenter
    }()
    
    init() {
        super.init(nibName: "CreateOrEditNote", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func setSaveButton(_ isActive: Bool) {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = isActive
    }
}

//MARK: Private CreateOrEditeNoteViewController
private extension CreateOrEditNoteViewController {
    
    func setupUI() {
        
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
    
    @objc func saveNoteButtonDidTap() {
        
        output?.saveNoteButtonDidTap(noteTextView.text)
    }
    
}
