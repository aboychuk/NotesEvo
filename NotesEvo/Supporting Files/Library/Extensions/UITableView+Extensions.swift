//
//  UITableView+Extensions.swift
//  iOSProjectSwift
//
//  Created by Andrew Boychuk on 11/17/17.
//  Copyright © 2017 Andrew Boychuk. All rights reserved.
//

import UIKit

extension UITableView {
    
    //MARK: - Instance Functions
    
    func reusableCellWith<T>(type: T.Type, index: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: typeString(type), for: index) as? T else {
            fatalError("no reusable cell registered")
        }
        
        return cell
    }
    
    ///Use this method if ios version is < 11, else use performBatchUpdate.
    func updateTableWith(block: () -> ()) {
        self.beginUpdates()
        block()
        self.endUpdates()
    }
    
    /// Registers a nib object containing a cell with the table view under a specified identifier if nib is nil, registers a class for use in creating new table cells.
    func registerCell<T: UITableViewCell>(type: T.Type) {
        let cellName = typeString(type)
        let nib = UINib.nib(from: type, bundle: .main)
        if nib == nil {
            self.register(type, forCellReuseIdentifier: cellName)
        } else {
            self.register(nib, forCellReuseIdentifier: cellName)
        }
    }
}
