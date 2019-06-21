//
//  NoteTableViewCell.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/20/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var contentLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
}

extension NoteTableViewCell: ViewFillable {
    typealias Model = Note

    func fillView(with model: Note) {
        self.contentLabel?.text = model.shortContent
        self.dateLabel?.text = model.date
        self.timeLabel?.text = model.time
    }
}
