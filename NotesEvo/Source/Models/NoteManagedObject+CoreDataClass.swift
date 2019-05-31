//
//  NoteManagedObject+CoreDataClass.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/30/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NoteManagedObject)
public class NoteManagedObject: NSManagedObject { }

extension NoteManagedObject: EntityConvertible {
    typealias Entity = Note
    
    func toEntity() -> Note? {
        guard let id = self.identifier,
            let date = self.modifyDate as Date?,
            let content = self.content
        else { return nil }
        
        return Note(id: id, date: date, content: content)
    }
    
}
