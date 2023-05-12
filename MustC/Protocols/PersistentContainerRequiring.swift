//
//  PersistentContainerRequiring.swift
//  MustC
//
//  Created by Eco Dev System on 12/05/2023.
//  Copyright © 2023 DonnyWals. All rights reserved.
//

import Foundation
import CoreData

protocol PersistentContainerRequiring {
    var persistentContainer: NSPersistentContainer! { get set }
}
