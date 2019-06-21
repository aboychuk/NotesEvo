//
//  Notification.Name+Extension.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 6/20/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation

extension Notification.Name {
    static var dataSourceChangedState: Notification.Name {
        return self.init(rawValue: "dataSourceChangedState")
    }
}
