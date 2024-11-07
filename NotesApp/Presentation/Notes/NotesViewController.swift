//
//  NotesViewController.swift
//  NotesApp
//
//  Created by Vladislav on 10.10.2022.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    private lazy var output: NotesViewOutput? = {        
        let presenter = NotesPresentor()
        presenter.view = self
        return presenter
    }()
    
    private let tableView = UITableView()
    private let separator = UIView()
    private var sections = [NotesSectionsData]()
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        output?.viewDidLoad()
    }
    
}

//MARK: UITableViewDataSource and UITableViewDelegate
extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as? NotesTableViewCell else { return UITableViewCell() }
        cell.configure(model: sections[indexPath.section].cells[indexPath.row], cellsCount: sections[indexPath.section].cells.count)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionHeader = sections[section].sectionType.localaizeHeader
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        output?.deleteNote(sections[indexPath.section].cells[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.didSelectCell(sections[indexPath.section].cells[indexPath.row])
    }
    
}

//MARK: NotesViewInput
extension NotesViewController: NotesViewInput {
    func reloadTableView(sections: [NotesSectionsData]) {
        self.sections = sections
        tableView.reloadData()
    }
    
    func pushCreateOrEditeViewController(noteID: String?,
                                         sectionType: NotesSectionsData.SectionsType) {
        let vc = CreateOrEditNoteViewController()
        vc.state = noteID == nil ? .create : .edit
        vc.noteID = noteID
        vc.sectionType = sectionType
        vc.onFinish = { [weak self] noteID, sectionType in
            guard let self else { return }
            self.output?.didAddCell(noteID , sectionType)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
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
}

//MARK: NotesViewController
private extension NotesViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.title = "Notes".localized()
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addNoteButtonDidTap))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign out".localized(),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(signOutButtonDidTap))
        if #available(iOS 16.0, *) {
            navigationController?.navigationBar.setNeedsLayout()
        }
        configureTableView()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        view.addSubview(separator)
        tableView.addSubview(refreshControl)

        separator.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                         bottom: tableView.topAnchor,
                         trailing: view.safeAreaLayoutGuide.trailingAnchor,
                         size: .init(width: 0, height: 2))
        separator.backgroundColor = .black

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 40
        tableView.anchor(top: nil,
                         leading: view.safeAreaLayoutGuide.leadingAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
    }
    
    @objc func addNoteButtonDidTap() {
        output?.addNoteButtonDidTap()
    }
    
    @objc func signOutButtonDidTap() {
        output?.singOutButtonDidTap()
    }
    
    @objc func refreshTableView(_ sender: AnyObject) {
        output?.refreshTableView()
    }
}
