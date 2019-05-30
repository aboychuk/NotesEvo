//
//  NoteView.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/30/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

class NoteView: UIView {

    // MARK: - Properties
    
    @IBOutlet weak var noteTextView: UITextView?
}

extension NoteView: ViewFillable, ModelFillable {
    typealias Model = Note
    
    func fillView(with model: Model) {
        self.noteTextView?.text = model.content
    }
    
    func fillModel() -> Model {
        guard let content = self.noteTextView?.text else { return Note() }
        
        return Note(date: Date(), content: content)
    }
}
