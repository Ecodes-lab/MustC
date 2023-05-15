//
//  NSManagedObjectContext.swift
//  MustC
//
//  Created by Eco Dev System on 15/05/2023.
//  Copyright © 2023 DonnyWals. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func persist(block: @escaping () -> Void) {
        perform {
            block()
            
            do {
                try self.save()
            } catch {
                self.rollback()
            }
        }
    }
}
