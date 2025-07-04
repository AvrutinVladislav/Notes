//
//  NotesViewController.swift
//  NotesApp
//
//  Created by Vladislav on 10.10.2022.
//

import UIKit
import CoreData

class NotesViewController: BaseViewController {
    
    var output: NotesViewOutput?
    
    private let tableView = UITableView()
    private let addButton = UIButton()
    private let clearButton = UIButton()
    private var sections = [NotesSectionsData]()
    private lazy var refreshControl = UIRefreshControl()
    private var isHiddenNotes = true {
        didSet {
            clearButton.setTitle(isHiddenNotes ? "Show all notes" : "Hide done notes", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
    
}

//MARK: NotesViewInput
extension NotesViewController: NotesViewInput {
    func reloadTableView(sections: [NotesSectionsData]) {
        self.sections = sections
        tableView.reloadData()
    }
    
    func pushCreateOrEditeViewController(noteID: String?,
                                         sectionType: NotesSectionsData.SectionsType,
                                         state: CreateOrEditeNoteState) {
        let vc = CreateOrEditNoteBuilder.build(id: noteID,
                                               sectionType: sectionType,
                                               state: state)
        vc.onFinish = { [weak self] noteID, sectionType in
            guard let self else { return }
            self.output?.didAddCell(noteID , sectionType)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popToSignIn() {        
        if let loginView = navigationController?.viewControllers.first(where: {$0 is SignInViewController}) {
            navigationController?.popToViewController(loginView, animated: true)
        }
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func showIndicator(_ isActive: Bool) {
        let indicator = UIActivityIndicatorView()
        indicator.center = view.center
        indicator.color = .black
        indicator.hidesWhenStopped = true
        if isActive {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
    
    func endRefresh() {
        refreshControl.endRefreshing()
    }
    
    func pushSettingsViewController() {
        navigationController?.pushViewController(SettingsBuilder.build(), animated: true)
    }
}

//MARK: NotesViewController
extension NotesViewController {
    
    override func setupUI() {
        setupNavigationBar(title: "Notes".localized(),
                           rightImage: UIImage(systemName: "gearshape"),
                           leftButtonTitle: "Sign out".localized())
        leftButtonAction = { [weak self] in
            self?.signOutButtonDidTap()
        }
        rightButtonAction = { [weak self] in
            self?.settingsButtonDidTap()
        }
        
        if #available(iOS 16.0, *) {
            navigationController?.navigationBar.setNeedsLayout()
        }

        tableView.register(NotesTableViewCell.self,
                           forCellReuseIdentifier: NotesTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = Colors.mainBackground
        tableView.tintColor = .clear
        tableView.showsVerticalScrollIndicator = false

        refreshControl.addTarget(self,
                                 action: #selector(refreshTableView),
                                 for: .valueChanged)
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.setImage(UIImage(systemName: "plus")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)),
                           for: .normal)
        addButton.layer.cornerRadius = 30
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = Colors.cellBorderColor.cgColor
        addButton.backgroundColor = .white
        addButton.tintColor = Colors.mainBackground
        addButton.addTarget(self,
                            action: #selector(addNoteButtonDidTap),
                            for: .touchUpInside)
        
        clearButton.setTitle("Show all notes", for: .normal)
        clearButton.setTitleColor(Colors.mainBackground, for: .normal)
        clearButton.layer.cornerRadius = 30
        clearButton.layer.borderWidth = 1
        clearButton.layer.borderColor = Colors.cellBorderColor.cgColor
        clearButton.backgroundColor = .white
        clearButton.tintColor = Colors.mainBackground
        clearButton.addTarget(self,
                            action: #selector(hideDoneNotes),
                            for: .touchUpInside)
    }
    
    override func addSubview() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(clearButton)
        tableView.addSubview(refreshControl)
    }
    
    override func addConstraints() {
        addButton.anchor(top: nil,
                         leading: nil,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         trailing: view.safeAreaLayoutGuide.trailingAnchor,
                         padding: .init(top: 0, left: 0, bottom: -10, right: -10),
                         size: .init(width: 60, height: 60))
        
        clearButton.anchor(top: nil,
                           leading: view.safeAreaLayoutGuide.leadingAnchor,
                           bottom: view.safeAreaLayoutGuide.bottomAnchor,
                           trailing: nil,
                           padding: .init(top: 10, left: 10, bottom: -10, right: 0),
                           size: .init(width: 150, height: 60))
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                         bottom: addButton.topAnchor,
                         trailing: view.safeAreaLayoutGuide.trailingAnchor,
                         padding: .init(top: 10, left: 10, bottom: -10, right: -10))
        
        refreshControl.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        refreshControl.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
    }
    
    @objc func addNoteButtonDidTap() {
        output?.addNoteButtonDidTap()
    }
    
    @objc func signOutButtonDidTap() {
        output?.singOutButtonDidTap()
    }
    
    @objc func refreshTableView() {
        output?.refreshTableView()
        tableView.reloadData()
    }
    
    @objc func hideDoneNotes() {
        isHiddenNotes.toggle()
        output?.doneNotesIsHidden(isHiddenNotes)
    }
    
    @objc func settingsButtonDidTap() {
        navigationController?.pushViewController(SettingsBuilder.build(), animated: true)
    }
}

//MARK: UITableViewDataSource and UITableViewDelegate
extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier,
                                                       for: indexPath) as? NotesTableViewCell
        else { return UITableViewCell() }
        cell.configure(model: sections[indexPath.section].cells[indexPath.row],
                       sectionType: sections[indexPath.section].sectionType)
        cell.doneButtonTapped = { [weak self] in
            guard let self else { return }
            self.output?.doneButtonTapped(self.sections[indexPath.section].cells[indexPath.row].id)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        let sectionHeader = sections[section].sectionType.localaizeHeader
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        output?.deleteNote(sections[indexPath.section].cells[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        output?.didSelectCell(sections[indexPath.section].cells[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .black
        header.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        let visualEffectView = UIVisualEffectView()
        visualEffectView.effect = UIBlurEffect(style: .extraLight)
        visualEffectView.layer.cornerRadius = 10
        visualEffectView.layer.masksToBounds = true
        visualEffectView.backgroundColor = .clear
        header.backgroundView = visualEffectView
    }
    
}

