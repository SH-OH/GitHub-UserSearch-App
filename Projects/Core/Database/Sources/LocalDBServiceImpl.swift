//
//  LocalDBServiceImpl.swift
//  Database
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation
import CoreData

import DatabaseInterface

final class LocalDBServiceImpl: LocalDBService {
    
    let container: NSPersistentContainer
    private(set) lazy var childbackgroundContext: NSManagedObjectContext = {
        let childContext = container.newBackgroundContext()
        return childContext
    }()
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func read<Entity: NSManagedObject>(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]
    ) async -> [Entity] {
        return await withCheckedContinuation { continuation in
            childbackgroundContext.perform {
                let request = Entity.fetchRequest()
                request.predicate = predicate
                request.sortDescriptors = sortDescriptors
                
                do {
                    guard let result: [Entity] = try self.childbackgroundContext.fetch(request) as? [Entity] else {
                        print("Read error: CastingFailed - \([Entity].self)")
                        continuation.resume(returning: [])
                        return
                    }
                    
                    continuation.resume(returning: result)
                } catch {
                    print("Read error: \(error)")
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    func update<Entity: NSManagedObject>(entity: Entity) async throws {
        guard childbackgroundContext.hasChanges else { return }
        
        return try await withCheckedThrowingContinuation { continuation in
            childbackgroundContext.perform {
                do {
                    try self.childbackgroundContext.save()
                    continuation.resume()
                } catch {
                    print("Update error: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func delete<Entity: NSManagedObject>(entity: Entity) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            childbackgroundContext.perform {
                do {
                    self.childbackgroundContext.delete(entity)
                    try self.childbackgroundContext.save()
                    continuation.resume()
                } catch {
                    print("Delete error: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
