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
    
    
    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillWith(model: Note) {
        self.contentLabel?.text = model.content
        self.dateLabel?.text = self.date(from: model.createDate)
        self.timeLabel?.text = self.time(from: model.createDate)
    }
    
    // TODO: Add formatter class
    
    // MARK: - Private
    
    private func time(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: date)
    }
    
    private func date(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        
        return formatter.string(from: date)

    }

}
