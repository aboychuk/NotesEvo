//
//  ModelFillable.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/30/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

protocol ModelFillable where Self: UIView {
    associatedtype Model
    
    func fill(model: Model) -> Model
}
