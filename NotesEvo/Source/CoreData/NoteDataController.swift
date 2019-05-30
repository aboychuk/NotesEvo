//
//  NoteDataController.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/30/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation

class NoteDataController {
    typealias Model = [Note]
    // MARK: - Properties
    
    private var model: Model?
    private let manager: CoreDataManager
    
    // MARK: - Init
    
    init(manager: CoreDataManager = CoreDataManager()) {
        self.manager = manager
    }
    
    // MARK: - Public
    
    func add(note: Note, completion: (Error?) -> ()) {
        self.manager.upsert(entities: [note]) { (error) in
            error.map { print("\($0)") }
        }
    }
    
    func fetchNotes(completion: @escaping ([Note]?) -> ()) {
        self.manager.get { [weak self] (result: Result<Model, Error>) in
            switch result {
            case .success(let notes):
                self?.model = notes
                completion(notes)
            case .failure(let error):
                completion(nil)
                print("\(error)")
            }
        }
    }
    
    // ADD remove
}
