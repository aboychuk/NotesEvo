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
    
    var noteList = [Note]()
    private var filteredTableData = [Note]()
    private var searchController = UISearchController(searchResultsController: nil)
    private lazy var addBarButton = UIBarButtonItem(barButtonSystemItem: .add,
                                       target: self,
                                       action: #selector(onAddButton))
    @IBOutlet weak var notesTableView: UITableView?
    
    // MARK: - View lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    // MARK: - Private
    
    private func setupView() {
        self.notesTableView?.registerCell(type: NoteTableViewCell.self)
        self.navigationItem.title = Constants.notes.value
        self.navigationItem.rightBarButtonItem = self.addBarButton
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
        let note = Note(date: Date(), content: Constants.defaultContent.value)
        let arrayModel = [Note](repeating: note, count: 10)
        self.noteList = arrayModel
    }

    
    // MARK: - Objc
    
    @objc private func onAddButton() {
        self.showNextVC(state: .add)
    }
}

extension NoteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.searchController.isActive ? self.filteredTableData.count : self.noteList.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = self.searchController.isActive
            ? self.filteredTableData[indexPath.row]
            : self.noteList[indexPath.row]
        let cell = tableView.reusableCellWith(type: NoteTableViewCell.self, index: indexPath)
        cell.fillView(with: note)
        
        return cell
    }
}

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let model = self.noteList[index]
        tableView.deselectRow(at: indexPath, animated: false)
        self.showNextVC(state: .detail(model: model))
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexpath) in
            let index = indexPath.row
            let model = self.noteList[index]
            self.showNextVC(state: .edit(model: model, index: index))
        }
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let index = indexPath.row
            self.noteList.remove(at: index)
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
            self.filteredTableData = self.noteList.filter { note in
                return note.content.lowercased().contains(searchText.lowercased())
            }
        } else {
            self.filteredTableData = self.noteList
        }
        self.notesTableView?.reloadData()
    }
}

extension NoteListViewController: ViewControllerDelegate {
    typealias Model = Note
    
    func didAdd(model: Note) {
        self.notesTableView?.updateTableWith { [weak self] in
            let index = 0
            self?.noteList.insert(model, at: index)
            let indexPath = IndexPath(row: index, section: index)
            self?.notesTableView?.insertRows(at: [indexPath], with: .left)
        }
    }
    
    func didEdit(model: Note, index: Int) {
        self.notesTableView?.updateTableWith { [weak self] in
            self?.noteList[index] = model
            let indexPath = IndexPath(row: index, section: 0)
            self?.notesTableView?.reloadRows(at: [indexPath], with: .right)
        }
    }
}
