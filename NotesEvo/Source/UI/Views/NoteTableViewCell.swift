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
    
    @IBOutlet weak var TextLabel: UILabel?
    @IBOutlet weak var DateLabel: UILabel?
    @IBOutlet weak var TimeLabel: UILabel?
    
    
    // MARK: - Override

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
