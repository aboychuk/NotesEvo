//
//  ViewFillable.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/30/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

protocol ViewFillable where Self: UIView {
    associatedtype Model
    
    func fillView(with model: Model)
}
