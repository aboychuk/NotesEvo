//
//  Note.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/20/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation
import CoreData

struct Note {
    
    // MARK: - Properties
    
    let id: String
    let modifyDate: Date
    let content: String
    
    // MARK: - Init
    
    init() {
        let date = Date()
        let content = Constants.empty.value
        self.init(date: date, content: content)
    }
    
    init(date: Date, content: String) {
        let id = UUID().uuidString
        self.init(id: id, date: date, content: content)
    }
    
    init(id: String, date: Date, content: String) {
        self.id = id
        self.modifyDate = date
        self.content = content
    }
}

extension Note: Equatable { }

extension Note: ManagedObjectConvertible {
    func toManagedObject(in context: NSManagedObjectContext) -> NoteManagedObject? {
        let note = NoteManagedObject.getOrCreateSingle(with: self.id, from: context)
        note.modifyDate = self.modifyDate as NSDate
        note.content = self.content
        
        return note
    }
}
