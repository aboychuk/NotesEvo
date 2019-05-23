//
//  ViewControllerDelegate.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/23/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

protocol ViewControllerDelegate where Self: UIViewController {
    associatedtype Model
    
    func didAdd(model: Model)
}
