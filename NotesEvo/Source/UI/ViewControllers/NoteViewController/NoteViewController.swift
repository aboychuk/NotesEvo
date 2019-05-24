//
//  NoteViewController.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/24/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

enum NoteViewControllerState {
    case add
    case detail(model: Note)
    case edit(model: Note, index: Int)
}

class NoteViewController: UIViewController, RootView {
    typealias ViewType = NoteView
    
    // MARK: - Properties
    
    var state = NoteViewControllerState.add
    weak var delegate: NoteListViewController?
    private var note: Note?
    
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
        case .edit(model: let note, index: _):
            self.prepareEditView(model: note)
        default:
            self.prepareAddView()
        }
    }
    
    private func prepareAddView() {
        
        self.prepareNavigationItem()
    }
    
    private func prepareDetailView(model: Note) {
        self.note = model
        self.fillView(model: model)
        self.rootView?.noteTextView?.isEditable = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                                 target: self,
                                                                 action: #selector(onShareButton))
    }
    
    private func prepareEditView(model: Note) {
        self.note = model
        self.fillView(model: model)
        self.prepareNavigationItem()
    }
    
    private func prepareNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                 target: NoteViewController.self,
                                                                 action: #selector(onSaveButton))
        
    }
    
    private func fillView(model: Note) {
        self.rootView?.noteTextView?.text = model.content
    }
    
    private func fillModel() {
        let content = self.rootView?.noteTextView?.text
        content.map { let note = Note(modifyDate: Date(), content: $0)
            self.note = note
        }
    }
    
    @objc private func onShareButton() {
        let shareText = self.note?.content ?? "No Data"
        let viewController = UIActivityViewController(activityItems: [shareText],
                                                      applicationActivities: [])
        self.present(viewController, animated: true)
    }
    
    @objc private func onSaveButton() {
        self.fillModel()
        guard let note = self.note else { return }
        switch self.state {
        case .edit(model: _, index: let index):
            self.delegate?.didEdit(model: note, index: index)
        default:
            self.delegate?.didAdd(model: note)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
}

