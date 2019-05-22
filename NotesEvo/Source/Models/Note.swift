//
//  Note.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/20/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation

class Note {
    
    // MARK: - Properties
    
    let createDate: Date
    var modifyDate: Date
    var content: String
    
    // MARK: - Init
    
    init(createDate: Date, content: String) {
        self.createDate = createDate
        self.modifyDate = createDate
        self.content = content
    }
}
