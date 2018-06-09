//
//  Room+CoreDataProperties.swift
//  Assgn_6
//
//  Created by Chintan Dinesh Koticha on 3/29/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//
//

import Foundation
import CoreData


extension Room {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Room> {
        return NSFetchRequest<Room>(entityName: "Room")
    }

    @NSManaged public var price: Int32
    @NSManaged public var roomName: String?
    @NSManaged public var roomType: String?
    @NSManaged public var roomImage: NSData?

}
