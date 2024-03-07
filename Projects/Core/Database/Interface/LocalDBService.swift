//
//  LocalDBService.swift
//  Database
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import Foundation
import CoreData

public protocol LocalDBService {
    var childbackgroundContext: NSManagedObjectContext { get }
    
    func read<Entity: NSManagedObject>(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]
    ) async -> [Entity]
    func update<Entity: NSManagedObject>(entity: Entity) async throws
    func delete<Entity: NSManagedObject>(entity: Entity) async throws
}
