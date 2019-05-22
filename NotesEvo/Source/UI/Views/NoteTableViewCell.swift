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
        let formatter = DateFormatter()
        
        self.contentLabel?.text = model.content.truncate(length: self.stringLength)
        self.dateLabel?.text = formatter.dateString(model.createDate)
        self.timeLabel?.text = formatter.timeString(model.createDate)
    }
    
    // MARK: - Constants
    
    private let stringLength = 100
}
