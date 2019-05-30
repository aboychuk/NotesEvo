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
    
    init() {
        self.init(date: Date(), content: "")
    }
    
    init(date: Date, content: String) {
        self.modifyDate = date
        self.content = content
    }
}

extension Note: Equatable { }
