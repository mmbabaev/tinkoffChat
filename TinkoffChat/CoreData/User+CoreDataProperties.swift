//
//  User+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 04.04.2018.
//  Copyright © 2018 mbabaev. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var about: String?
    @NSManaged public var appUser: AppUser?

}
