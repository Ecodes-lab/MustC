//
//  NSPersistentContainer+Ext.swift
//  MustC
//
//  Created by Eco Dev System on 12/05/2023.
//  Copyright © 2023 DonnyWals. All rights reserved.
//

import Foundation
import CoreData

extension NSPersistentContainer {
    func saveContextIfNeeded() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
