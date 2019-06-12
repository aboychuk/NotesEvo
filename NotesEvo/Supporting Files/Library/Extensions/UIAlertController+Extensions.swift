//
//  UIAlertController+Extensions.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 6/6/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    @discardableResult
    public func addAction(title: String, style: UIAlertAction.Style = .default, handler: @escaping (UIAlertAction) -> ()) -> Self {
        self.addAction(UIAlertAction(title: title, style: style, handler: handler))
        
        return self
    }
    
    public static func actionSheet(title: String? = nil, message: String? = nil) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    }
    
    public static func alert(title: String? = nil, message: String? = nil) -> UIAlertController {
        return UIAlertController.init(title: title, message: message, preferredStyle: .alert)
    }
    
}
