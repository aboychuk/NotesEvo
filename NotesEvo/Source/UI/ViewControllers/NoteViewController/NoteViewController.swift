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
    private lazy var actionBarButton = UIBarButtonItem(barButtonSystemItem: .action,
                                                       target: self,
                                                       action: #selector(onShareButton))
    private lazy var saveBarButton = UIBarButtonItem(barButtonSystemItem: .save,
                                                     target: self,
                                                     action: #selector(onSaveButton))
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
        self.addSaveButton()
    }
    
    private func prepareDetailView(model: Note) {
        self.note = model
        self.rootView?.fillView(with: model)
        self.rootView?.noteTextView?.isEditable = false
        self.navigationItem.rightBarButtonItem = self.actionBarButton
    }
    
    private func prepareEditView(model: Note) {
        self.note = model
        self.rootView?.fillView(with: model)
        self.addSaveButton()
    }
    
    private func addSaveButton() {
        self.navigationItem.rightBarButtonItem = self.saveBarButton
    }
    
    // MARK: - Objc
    
    @objc private func onShareButton() {
        let shareText = self.note?.content ?? "No Data"
        let viewController = UIActivityViewController(activityItems: [shareText],
                                                      applicationActivities: [])
        self.present(viewController, animated: true)
    }
    
    @objc private func onSaveButton() {
        self.note = self.rootView?.fillModel()
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
