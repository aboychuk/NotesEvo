//
//  Note.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/20/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation

struct Note {
    
    // MARK: - Properties
    
    var modifyDate: Date
    var content: String
    
    // MARK: - Init
    
    init(modifyDate: Date, content: String) {
        self.modifyDate = modifyDate
        self.content = content
    }
}
