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
    
    var notesModel = ArrayModel<Note>()
    private var filteredTableData = [Note]()
    private var coreData = NoteDataController()
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
        self.coreData.fetchNotes { [weak self] noteArray in
            noteArray.map { self?.notesModel.add(elements: $0) }
            self?.notesTableView?.reloadData()
        }
    }

    
    // MARK: - Objc
    
    @objc private func onAddButton() {
        self.showNextVC(state: .add)
    }
}

extension NoteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.searchController.isActive ? self.filteredTableData.count : self.notesModel.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = self.searchController.isActive
            ? self.filteredTableData[indexPath.row]
            : self.notesModel.elementAt(index: indexPath.row)
        let cell = tableView.reusableCellWith(type: NoteTableViewCell.self, index: indexPath)
        cell.fillView(with: note)
        
        return cell
    }
}

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let model = self.notesModel.elementAt(index: index)
        tableView.deselectRow(at: indexPath, animated: false)
        self.showNextVC(state: .detail(model: model))
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { [weak self] (action, indexpath) in
            let index = indexPath.row
            let model = self?.notesModel[index]
            model.map { self?.showNextVC(state: .edit(model: $0, index: index)) }
            
        }
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            let index = indexPath.row
            if let model = self?.notesModel[index] {
                self?.coreData.remove(note: model) { error in print(error!)}
            }
            self?.notesModel.removeElement(at: index)
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
            self.filteredTableData = self.notesModel.filter { note in
                return note.content.lowercased().contains(searchText.lowercased())
            }
        } else {
            self.filteredTableData = self.notesModel.allElements()
        }
        self.notesTableView?.reloadData()
    }
}

extension NoteListViewController: ViewControllerDelegate {
    typealias Model = Note
    
    func didAdd(model: Note) {
        self.notesTableView?.updateTableWith { [weak self] in
            let index = 0
            self?.notesModel.insert(element: model, index: index)
            self?.coreData.upsert(note: model, completion: { error in print(error!)} )
            let indexPath = IndexPath(row: index, section: index)
            self?.notesTableView?.insertRows(at: [indexPath], with: .left)
        }
    }
    
    func didEdit(model: Note, index: Int) {
        self.notesTableView?.updateTableWith { [weak self] in
            self?.notesModel[index] = model
            self?.coreData.upsert(note: model, completion: { error in print(error!)} )
            let indexPath = IndexPath(row: index, section: 0)
            self?.notesTableView?.reloadRows(at: [indexPath], with: .right)
        }
    }
}
