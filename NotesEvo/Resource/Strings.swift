//
//  Strings.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/23/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation

enum Strings: String {
    
    // MARK: - Properties
    
    var value: String {
        return self.rawValue
    }
    
    var capitalized: String {
        return self.value.capitalized
    }
    
    // MARK: - Cases
    
    case notes
    case appName = "NotesEvo"
    case sort
    case empty
    case edit
    case delete
    case cancel
    case defaultContent = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
    
}
