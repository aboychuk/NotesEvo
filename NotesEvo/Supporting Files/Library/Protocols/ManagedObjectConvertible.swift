//
//  ManagedObjectConvertible.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/30/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import CoreData

protocol ManagedObjectConvertible {
    associatedtype ManagedObject: NSManagedObject, EntityConvertible
    
    func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject?
}
