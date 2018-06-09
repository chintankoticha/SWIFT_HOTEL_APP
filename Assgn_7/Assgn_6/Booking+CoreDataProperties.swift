//
//  Booking+CoreDataProperties.swift
//  Assgn_6
//
//  Created by Chintan Dinesh Koticha on 3/17/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//
//

import Foundation
import CoreData


extension Booking {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Booking> {
        return NSFetchRequest<Booking>(entityName: "Booking")
    }

    @NSManaged public var bookingName: String?
    @NSManaged public var fromDate: NSDate?
    @NSManaged public var toDate: NSDate?
    @NSManaged public var cust: Customer?
    @NSManaged public var room: Room?

}
