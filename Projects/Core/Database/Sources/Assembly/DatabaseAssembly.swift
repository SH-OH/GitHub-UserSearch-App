//
//  DatabaseAssembly.swift
//  DatabaseInterface
//
//  Created by Oh Sangho on 2/21/24.
//  Copyright © 2024 com.shoh. All rights reserved.
//

import CoreData
import Swinject

import DatabaseInterface
import GlobalThirdPartyLibrary

public final class DatabaseAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(NSPersistentContainer.self) { (_, name: String, model: NSManagedObjectModel) in
            let container = NSPersistentContainer(name: name, managedObjectModel: model)
            container.loadPersistentStores { _, error in
                if let error {
                    fatalError("CoreData Load error: \(error.localizedDescription)")
                }
            }
            
            return container
        }.inObjectScope(.container)
        
        container.register(LocalDBService.self) { (r, name: String, model: NSManagedObjectModel) in
            LocalDBServiceImpl(
                container: r.resolve(NSPersistentContainer.self, arguments: name, model)
            )
        }
    }
}
