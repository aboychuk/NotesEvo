//
//  StructConvertible.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/30/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation
import CoreData

protocol EntityConvertible {
    associatedtype Entity
    
    func toEntity() -> Entity?
}

extension EntityConvertible where Self: NSManagedObject {
    
    static func getOrCreateSingle(with id: String, from context: NSManagedObjectContext) -> Self {
        let result = self.single(with: id, from: context) ?? self.insertNew(in: context)
        result.setValue(id, forKey: "identifier")
        return result
    }
    
    static func single(from context: NSManagedObjectContext, with predicate: NSPredicate?,
                       sortDescriptors: [NSSortDescriptor]?) -> Self?
    {
        return fetch(from: context, with: predicate,
                     sortDescriptors: sortDescriptors, fetchLimit: 0)?.first
    }
    
    static func single(with id: String, from context: NSManagedObjectContext) -> Self? {
        let predicate = NSPredicate(format: "identifier == %@", id)
        return self.single(from: context, with: predicate, sortDescriptors: nil)
    }
    
    static func insertNew(in context: NSManagedObjectContext) -> Self {
        return Self(context:context)
    }
    
    static func fetch(from context: NSManagedObjectContext, with predicate: NSPredicate?,
                      sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?) -> [Self]? {
        
        let fetchRequest = Self.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        fetchRequest.returnsObjectsAsFaults = false
        
        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        var result: [Self]?
        context.performAndWait { () -> () in
            do {
                result = try context.fetch(fetchRequest) as? [Self]
            } catch {
                result = nil
                print("CoreData fetch error \(error)")
            }
        }
        return result
    }
    
    static func objectForRemove(with id: String, context: NSManagedObjectContext) -> Self? {
        guard let result = self.single(with: id, from: context) else { return nil }
        context.delete(result)
        
        return result
    }
}
