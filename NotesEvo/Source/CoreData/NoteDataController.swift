//
//  NoteDataController.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/30/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation

// TODO: Fix Dupplicateion

class NoteDataController {
    typealias Model = ArrayModel<Note>
    
    // MARK: - Properties
    
    
    var count: Int {
        return self.data.count
    }
    private var data = Model()
    private let manager: CoreDataManager
    
    // MARK: - Init
    
    init(manager: CoreDataManager = CoreDataManager()) {
        self.manager = manager
    }
    
    // MARK: - Public
    
    func load(completion: @escaping () -> ()) {
        let sortDescriptors = [NSSortDescriptor(key: "modifyDate", ascending: false)]
        let fetchBatchSize = 20
        self.manager.get(sortDescriptors: sortDescriptors, fetchBatchSize: fetchBatchSize)
        { [weak self] (result: Result<[Note], Error>) in
            switch result {
            case .success(let notes):
                self?.data.add(elements: notes)
                completion()
            case .failure(let error):
                completion()
                print("\(error)")
            }
        }
    }
    
    func search(text: String, completion: @escaping () -> ()) {
        let predicate = NSPredicate(format: "content contains[c] '\(text)'")
        let sortDescriptors = [NSSortDescriptor(key: "modifyDate", ascending: true)]
        let fetchBatchSize = 20
        self.manager.get(with: predicate, sortDescriptors: sortDescriptors, fetchBatchSize: fetchBatchSize)
        { [weak self] (result: Result<[Note], Error>) in
            switch result {
            case .success(let notes):
                self?.data.removeAll()
                self?.data.add(elements: notes)
                completion()
            case .failure(let error):
                completion()
                print("\(error)")
            }
        }
    }
    
    // TODO: add error handling in UI
    
    func add(note: Note, at index: Int) {
        self.data.insert(element: note, index: index)
        self.manager.upsert(entities: [note]) { error in error.map { print("\($0)") }}
    }
    
    func remove(at index: Int) {
        let model = self.data[index]
        guard let note = model else { return }
        self.manager.remove(entity: note) { error in error.map { print("\($0)") }}
    }
    
    func update(note: Note, index: Int) {
        self.data[index] = note
        self.manager.upsert(entities: [note]) { error in error.map { print("\($0)") }}
    }
    
    func note(at index: Int) -> Note? {
        return self.data[index]
    }
}
