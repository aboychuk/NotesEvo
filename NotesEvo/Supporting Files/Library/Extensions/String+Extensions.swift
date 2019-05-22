//
//  String+Extensions.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/22/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation

extension String {
    
    /// Returns truncated string of given length and trailing, by default trailing string is "...". The length is calculated including trailing symbols count.
    public func truncate(length: Int, trailing: String = "...") -> String {
        if self.count > length {
            return String(self.prefix(length - trailing.count)) + trailing
        } else {
            return self
        }
    }
}
