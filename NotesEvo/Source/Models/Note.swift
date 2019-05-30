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
    
    let id: String
    let modifyDate: Date
    let content: String
    
    // MARK: - Init
    
    init() {
        let id = UUID().uuidString
        let date = Date()
        let content = Constants.empty.value
        self.init(id: id, date: date, content: content)
    }
    
    init(id: String, date: Date, content: String) {
        self.id = id
        self.modifyDate = date
        self.content = content
    }
}

extension Note: Equatable { }
