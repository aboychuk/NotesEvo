//
//  CoreDataManager.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/30/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import CoreData

private enum CoreDataManagerError: Error {
    case canNotFetch(String)
    case canNotSave(Error)
}

class CoreDataManager {
    
    // MARK: - Properties
    
    let coreData: CoreDataService
    
    // MARK: - Init
    
    init(coreData: CoreDataService = CoreDataService.shared) {
        self.coreData = coreData
    }
    
    // MARK: - Public
    
    /// Gets entities from storage on background thread
    func get<Entity: ManagedObjectConvertible>(with predicate: NSPredicate? = nil,
                                               sortDescriptors: [NSSortDescriptor]? = nil,
                                               fetchLimit: Int? = nil,
                                               fetchBatchSize: Int? = 20,
                                               completion: @escaping (Result<[Entity], Error>) -> ())
    {
        self.coreData.performBackgroundTask { context in
            do {
                let fetchRequest = Entity.ManagedObject.fetchRequest()
                fetchRequest.predicate = predicate
                fetchRequest.sortDescriptors = sortDescriptors
                if let fetchLimit = fetchLimit, let fetchBatchSize = fetchBatchSize {
                    fetchRequest.fetchLimit = fetchLimit
                    fetchRequest.fetchBatchSize = fetchBatchSize
                }
                let results = try context.fetch(fetchRequest) as? [Entity.ManagedObject]
                let items: [Entity] = results?.compactMap { $0.toEntity() as? Entity } ?? []
                completion(.success(items))
            } catch {
                let fetchError = CoreDataManagerError.canNotFetch("Cannot fetch error: \(error))")
                completion(.failure(fetchError))
            }
        }
    }
    
    /// If entity already exists updates it else creates new one. executes in background
    func upsert<Entity: ManagedObjectConvertible>(entities: [Entity],
                                                  completion: @escaping (Error?) -> ())
    {
        self.coreData.performBackgroundTask { context in
            _ = entities.compactMap({ (entity) -> Entity.ManagedObject? in
                return entity.toManagedObject(in: context)
            })
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(CoreDataManagerError.canNotSave(error))
            }
        }
    }
    
    /// Removes entity from storage. Executes in background
    func remove<Entity: ManagedObjectConvertible>(entity: Entity,
                                                  completion: @escaping (Error?) -> ())
    {
        self.coreData.performBackgroundTask { context in
            let object = entity.toManagedObject(in: context)
            object.map { context.delete($0) }
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(CoreDataManagerError.canNotSave(error))
            }
        }
    }
}


