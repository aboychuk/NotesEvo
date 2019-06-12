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
    
    private var dataController = NotesDataController()
    private var searchController = UISearchController(searchResultsController: nil)
    private lazy var addBarButton = UIBarButtonItem(barButtonSystemItem: .add,
                                       target: self,
                                       action: #selector(onAddButton))
    private lazy var sortBarButton = UIBarButtonItem(image: UIImage(named: "Sort"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(onSortButton))
    @IBOutlet weak var notesTableView: UITableView?
    
    // MARK: - View lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
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
        self.dataController.loadNotes { [weak self] in self?.notesTableView?.reloadData() }
    }
    
    private func prepareActionController() -> UIAlertController {
        let actionVC = UIAlertController.actionSheet()
        actionVC.addAction(title: "Old to new") { [weak self] action in
            self?.dataController.loadNotes(ascending: true) { [weak self] in
                self?.notesTableView?.reloadData()
            }
        }
        actionVC.addAction(title: "New to old") { [weak self] action in
            self?.dataController.loadNotes(ascending: false) { [weak self] in
                self?.notesTableView?.reloadData()
            }
        }
        actionVC.addAction(UIAlertAction(title: Strings.cancel.capitalized, style: .cancel, handler: nil))
        
        return actionVC
    }

    
    // MARK: - Objc
    
    @objc private func onAddButton() {
        self.showNextVC(state: .add)
    }
    
    @objc private func onSortButton() {
        let controller = self.prepareActionController()
        self.present(controller, animated: true)
    }
}

extension NoteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataController.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = self.dataController.note(at: indexPath.row)
        let cell = tableView.reusableCellWith(type: NoteTableViewCell.self, index: indexPath)
        note.map { cell.fillView(with: $0) }
        
        return cell
    }
}

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataController.note(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
        model.map { self.showNextVC(state: .detail(model: $0)) }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default,
                                              title: Strings.edit.capitalized) { [weak self] (action, indexpath) in
            let index = indexPath.row
            let model = self?.dataController.note(at: index)
            model.map { self?.showNextVC(state: .edit(model: $0, index: index)) }
        }
        let deleteAction = UITableViewRowAction(style: .destructive,
                                                title: Strings.delete.capitalized) { [weak self] (action, indexPath) in
            self?.dataController.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
            self.dataController.loadNotes(matching: searchText) { [weak self] in self?.notesTableView?.reloadData() }
        }
        if !self.searchController.isActive {
            self.dataController.loadNotes { [weak self] in self?.notesTableView?.reloadData() }
        }
    }
}

extension NoteListViewController: ViewControllerDelegate {
    typealias Model = Note
    
    func didAdd(model: Note) {
        self.notesTableView?.performBatchUpdates({
            let index = 0
            self.dataController.add(note: model, at: index)
            let indexPath = IndexPath(row: index, section: index)
            self.notesTableView?.insertRows(at: [indexPath], with: .left)
        })
    }
    
    func didEdit(model: Note, index: Int) {
        self.notesTableView?.performBatchUpdates({
            self.dataController.update(note: model, index: index)
            let indexPath = IndexPath(row: index, section: 0)
            self.notesTableView?.reloadRows(at: [indexPath], with: .right)
        })
    }
}
