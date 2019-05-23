//
//  NoteViewController.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/17/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

enum NoteViewControllerState {
    case add
    case detail(model: Note)
}

class NoteViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var noteTextView: UITextView?
    var note: Note?
    var state = NoteViewControllerState.add
    weak var delegate: NotesTableViewController?
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    // MARK: - Private
    
    private func setupView() {
        let state = self.state
        switch state {
        case .detail(model: let note):
            self.prepareDetailView(model: note)
        default:
            self.prepareAddView()
        }
    }
    
    private func prepareAddView() {
        // add dismiss keyboard
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                target: self,
                                                                action: #selector(onAddButton))
    }
    
    private func prepareDetailView(model: Note) {
        self.note = model
        self.fillView(model: model)
        self.noteTextView?.isEditable = false
    }
    
    private func fillView(model: Note) {
        self.noteTextView?.text = model.content
    }
    
    private func fillModel() {
        let content = self.noteTextView?.text
        content.map { let note = Note.init(createDate: Date(), content: $0)
            self.note = note
        }
    }
    
    @objc private func onAddButton() {
        self.fillModel()
        guard let note = self.note else { return }
            self.delegate?.didAdd(model: note)
            self.navigationController?.popToRootViewController(animated: true)
    }

}

