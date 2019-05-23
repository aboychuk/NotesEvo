//
//  NotesTableViewController.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/21/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var noteList = [Note]()
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Delete test
        self.prepareTest()
    }
    
    // MARK: - Override
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.detailSegue.value {
            self.prepareDetail(segue: segue)
        }
        if segue.identifier == Constants.addSegue.value {
            self.prepareAdd(segue: segue)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = self.noteList[indexPath.row]
        let cell = tableView.reusableCellWith(type: NoteTableViewCell.self, index: indexPath)
        cell.fillWith(model: note)
        
        return cell
    }
    
    // MARK: - Private
    
    private func prepareAdd(segue: UIStoryboardSegue) {
        guard let destinationVC = segue.destination as? NoteViewController else { return }
        destinationVC.state = NoteViewControllerState.add
        destinationVC.delegate = self
    }
    
    private func prepareDetail(segue: UIStoryboardSegue) {
        guard let destinationVC = segue.destination as? NoteViewController,
            let index = tableView.indexPathForSelectedRow?.row else { return }
        destinationVC.state = NoteViewControllerState.detail(model: self.noteList[index])
    }
    
    private func prepareTest() {
        let note = Note(createDate: Date(), content: Constants.defaultContent.value)
        let arrayModel = [Note](repeating: note, count: 10)
        self.noteList = arrayModel
    }
}

extension NotesTableViewController: ViewControllerDelegate {
    typealias Model = Note
    
    func didAdd(model: Note) {
        self.tableView.updateTableWith { [weak self] in
            // TODO: Make extension
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .left)
            self?.noteList.insert(model, at: 0)
        }
    }
    
}
