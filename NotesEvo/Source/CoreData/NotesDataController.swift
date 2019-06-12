//
//  NotesDataController.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/30/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation

// TODO: Fix Dupplicateion

class NotesDataController {
    typealias Model = ArrayModel<Note>
    
    // MARK: - Properties
    
    var count: Int {
        return self.data.count
    }
    private var data = Model()
    private let manager: CoreDataManager
    private let batchSize = 20
    
    // MARK: - Init
    
    init(manager: CoreDataManager = CoreDataManager()) {
        self.manager = manager
    }
    
    // MARK: - Public
    /// Loads notesData with batchSize of 20 in background returns completionHandler on main thread
    func loadNotes(matching query: String = "",ascending: Bool = false, completion: @escaping () -> ()) {
        let sortDescriptors = [NSSortDescriptor(key: "modifyDate", ascending: ascending)]
        let predicate = query.count != 0 ? NSPredicate(format: "content contains[c] '\(query)'") : nil
        
        self.manager.get(with: predicate, sortDescriptors: sortDescriptors, fetchBatchSize: self.batchSize)
        { [weak self] (result: Result<[Note], Error>) in
            switch result {
            case .success(let notes):
                self?.data.removeAll()
                self?.data.add(elements: notes)
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion()
                }
                print("\(error)")
            }
        }
    }
    
    // TODO: add error handling in UI
    
    func add(note: Note, at index: Int) {
        self.data.insert(element: note, index: index)
        self.manager.upsert(entities: [note]) { $0.map { print("\($0)") }}
    }
    
    func remove(at index: Int) {
        let model = self.data[index]
        guard let note = model else { return }
        self.manager.remove(entity: note) { $0.map { print("\($0)") }}
    }
    
    func update(note: Note, index: Int) {
        self.data[index] = note
        self.manager.upsert(entities: [note]) { $0.map { print("\($0)") }}
    }
    
    func note(at index: Int) -> Note? {
        return self.data[index]
    }
}
