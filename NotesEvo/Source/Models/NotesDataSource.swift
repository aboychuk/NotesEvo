//
//  NotesDataController.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/30/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import Foundation

public enum DataSourceState {
    case processing
    case loaded
    case added(at: Int)
    case removed(at: Int)
    case updated(at: Int)
    case error(_: Error)
}

// TODO: Fix Dupplicateion

class NotesDataSource {
    
    typealias Model = ArrayModel<Note>
    
    // MARK: - Properties
    
    var count: Int {
        return self.data.count
    }
    private var data = Model()
    private let manager: CoreDataManager
    private let batchSize = 20
    private(set) var ascending: Bool = false
    private var state: DataSourceState? {
        didSet {
            DispatchQueue.main.async {
                self.notifyOfState()
            }
        }
    }
    private let notificationCenter: NotificationCenter
    
    // MARK: - Init
    
    init(manager: CoreDataManager = CoreDataManager(), notificationCenter: NotificationCenter = .default) {
        self.manager = manager
        self.notificationCenter = notificationCenter
    }
    
    // MARK: - Public
    
    func load() {
        self.data.removeAll()
        let sortDescriptors = [NSSortDescriptor(key: "modifyDate", ascending: self.ascending)]
        self.loadNotes(predicate: nil, sortDescriptors: sortDescriptors)
    }
    
    func sortNotes(ascending: Bool) {
        if ascending != self.ascending {
            self.data.removeAll()
            let sortDescriptors = [NSSortDescriptor(key: "modifyDate", ascending: ascending)]
            self.loadNotes(predicate: nil, sortDescriptors: sortDescriptors)
        }
    }
    
    func searchNotes(matching query: String) {
        if query.count != 0 {
            self.data.removeAll()
            let predicate = NSPredicate(format: "content contains[c] '\(query)'")
            self.loadNotes(predicate: predicate, sortDescriptors: nil)
        }
    }
    
    // TODO: add error handling in UI
    
    func add(note: Note, at index: Int) {
        self.data.insert(element: note, index: index)
        self.manager.upsert(entities: [note]) { $0.map { print("\($0)") }}
        self.state = .added(at: index)
    }
    
    func remove(at index: Int) {
        let model = self.data[index]
        guard let note = model else { return }
        self.data.removeElement(at: index)
        self.manager.remove(entity: note) { $0.map { print("\($0)") }}
        self.state = .removed(at: index)
    }
    
    func update(note: Note, index: Int) {
        self.data[index] = note
        self.manager.upsert(entities: [note]) { $0.map { print("\($0)") }}
        self.state = .updated(at: index)
    }
    
    func note(at index: Int) -> Note? {
        return self.data[index]
    }
    
    // MARK: - Private
    
    fileprivate func notifyOfState() {
        let state = self.state
        self.notificationCenter.post(name: .dataSourceChangedState, object: state)
    }
    
    /// Loading notesData with batchSize of 20 in background changes model state on main thread.
    private func loadNotes(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) {
        self.state = .processing
        self.manager.get(with: predicate,
                         sortDescriptors: sortDescriptors,
                         fetchBatchSize: self.batchSize)
        { [weak self] (result: Result<[Note], Error>) in
            switch result {
            case .success(let notes):
                self?.data.add(elements: notes)
                self?.state = .loaded
            case .failure(let error):
                self?.state = .error(error)
            }
        }
    }

}
