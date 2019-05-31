//
//  NoteManagedObject+CoreDataProperties.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/30/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//
//

import Foundation
import CoreData


extension NoteManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteManagedObject> {
        return NSFetchRequest<NoteManagedObject>(entityName: "NoteManagedObject")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var modifyDate: NSDate?
    @NSManaged public var content: String?

}
