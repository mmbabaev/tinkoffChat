//
//  AppUser+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 04.04.2018.
//  Copyright © 2018 mbabaev. All rights reserved.
//
//

import Foundation
import CoreData


extension AppUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppUser> {
        return NSFetchRequest<AppUser>(entityName: "AppUser")
    }

    @NSManaged public var currentUser: User?

}
