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
    
    var noteList: [Note]
    var searchController: SearchViewController
    var filteredTableData: [Note] {
        didSet {
            if self.filteredTableData != oldValue {
                self.notesTableView?.reloadData()
            }
        }
    }
    @IBOutlet weak var notesTableView: UITableView?
    
    // MARK: - Init
    
    init(model: [Note]) {
        self.noteList = model
        let searchVC = SearchViewController(model: model)
        self.searchController = searchVC
        self.filteredTableData = searchVC.filteredModel
        
        super.init(nibName: typeString(NoteListViewController.self), bundle: .main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let model = [Note]()
        self.noteList = model
        let searchVC = SearchViewController(model: model)
        self.searchController = searchVC
        self.filteredTableData = searchVC.filteredModel
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - View lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.registerCell()
        self.navigationItem.searchController = self.searchController
//        self.notesTableView?.tableHeaderView = self.searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = self.notesTableView?.indexPathForSelectedRow {
            self.notesTableView?.deselectRow(at: index, animated: true)
        }
    }
    
    // MARK: - Private
    
    private func setupView() {
        self.navigationItem.title = Constants.notes.value
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add,
                                                                      target: self,
                                                                      action: #selector(onAddButton))
    }
    
    private func registerCell() {
        let cellName = typeString(NoteTableViewCell.self)
        let nib = UINib(nibName: cellName, bundle: .main)
        self.notesTableView?.register(nib, forCellReuseIdentifier: cellName)
    }
    
    @objc private func onAddButton() {
        self.showNextVC(state: .add)
    }
    
    private func showNextVC(state: NoteViewControllerState) {
        let viewController = NoteViewController()
        viewController.state = state
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
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
        cell.fillWith(model: note)
        
        return cell
    }
}

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let model = self.noteList[index]
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
