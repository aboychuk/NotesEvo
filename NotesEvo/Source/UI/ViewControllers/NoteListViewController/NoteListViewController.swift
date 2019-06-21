//
//  NoteListViewController.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/23/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

class NoteListViewController: UIViewController {

    // MARK: - Properties
    
    private var dataSource = NotesDataSource()
    private var searchController = UISearchController(searchResultsController: nil)
    private lazy var addBarButton = UIBarButtonItem(barButtonSystemItem: .add,
                                       target: self,
                                       action: #selector(onAddButton))
    private lazy var sortBarButton = UIBarButtonItem(image: UIImage(named: "Sort"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(onSortButton))
    private let notificationCenter: NotificationCenter = .default
    @IBOutlet weak var notesTableView: UITableView?
    
    // MARK: - View lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.notificationCenter.addObserver(self,
                                             selector: #selector(dataSourceChangedState),
                                             name: .dataSourceChangedState,
                                             object: nil)
    }
    
    // MARK: - Private
    
    private func setupView() {
        self.notesTableView?.registerCell(type: NoteTableViewCell.self)
        self.navigationItem.title = Strings.notes.capitalized
        self.navigationItem.rightBarButtonItems = [self.addBarButton, self.sortBarButton]
        self.setupSearchController()
        self.prepareTest()
    }
    
    private func setupSearchController() {
        let vc = self.searchController
        vc.searchResultsUpdater = self
        vc.hidesNavigationBarDuringPresentation = false
        vc.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = vc
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    // MARK: - Navigation
    
    private func showNextVC(state: NoteViewControllerState) {
        let viewController = NoteViewController()
        viewController.state = state
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func prepareTest() {
        self.dataSource.load()
    }
    
    private func prepareActionController() -> UIAlertController {
        let actionVC = UIAlertController.actionSheet()
        if self.dataSource.ascending == false {
            actionVC.addAction(title: "Old to new") { [weak self] action in
                self?.dataSource.sortNotes(ascending: true)
            }
        } else {
            actionVC.addAction(title: "New to old") { [weak self] action in
                self?.dataSource.sortNotes(ascending: false)
            }
        }
        
        actionVC.addAction(UIAlertAction(title: Strings.cancel.capitalized, style: .cancel, handler: nil))
        
        return actionVC
    }
    
    private func indexPath(from index: Int) -> IndexPath {
        return IndexPath(row: index, section: 0)
    }
    
    // MARK: - Objc

    @objc private func onAddButton() {
        self.showNextVC(state: .add)
    }
    
    @objc private func onSortButton() {
        let controller = self.prepareActionController()
        self.present(controller, animated: true)
    }
    
    @objc private func dataSourceChangedState(_ notification: Notification) {
        guard let state = notification.object as? DataSourceState else {
            let object = notification.object as Any
            assertionFailure("Invalid object: \(object)")
            
            return
        }
        // TODO: add error processing handler
        switch state {
        case .added(let index):
            self.notesTableView?.insertRows(at: [self.indexPath(from: index)], with: .left)
        case .removed(let index):
            self.notesTableView?.deleteRows(at: [self.indexPath(from: index)], with: .fade)
        case .updated(let index):
            self.notesTableView?.reloadRows(at: [self.indexPath(from: index)], with: .right)
        case .loaded:
            // TODO Hide spinner
            self.notesTableView?.reloadData()
        default:
            self.notesTableView?.reloadData()
        }
    }
}

extension NoteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = self.dataSource.note(at: indexPath.row)
        let cell = tableView.reusableCellWith(type: NoteTableViewCell.self, index: indexPath)
        note.map { cell.fillView(with: $0) }
        
        return cell
    }
}

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource.note(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
        model.map { self.showNextVC(state: .detail(model: $0)) }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default,
                                              title: Strings.edit.capitalized) { [weak self] (action, indexpath) in
            let index = indexPath.row
            let model = self?.dataSource.note(at: index)
            model.map { self?.showNextVC(state: .edit(model: $0, index: index)) }
        }
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: Strings.delete.capitalized) { [weak self] (action, indexPath) in
            self?.dataSource.remove(at: indexPath.row)
        }
        editAction.backgroundColor = .gray
        deleteAction.backgroundColor = .red
        
        return [editAction, deleteAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension NoteListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            self.dataSource.searchNotes(matching: searchText)
        }
        if !self.searchController.isActive {
            self.dataSource.load()
        }
    }
}

extension NoteListViewController: ViewControllerDelegate {
    typealias Model = Note
    
    func didAdd(model: Note) {
        let index = 0
        self.dataSource.add(note: model, at: index)
    }
    
    func didEdit(model: Note, index: Int) {
        self.dataSource.update(note: model, index: index)
    }
}
