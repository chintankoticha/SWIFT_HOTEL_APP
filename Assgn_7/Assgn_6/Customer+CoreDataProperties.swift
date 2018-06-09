//
//  Customer+CoreDataProperties.swift
//  Assgn_6
//
//  Created by Chintan Dinesh Koticha on 3/29/18.
//  Copyright © 2018 Chintan Dinesh Koticha. All rights reserved.
//
//

import Foundation
import CoreData


extension Customer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer> {
        return NSFetchRequest<Customer>(entityName: "Customer")
    }

    @NSManaged public var address: String?
    @NSManaged public var custId: String?
    @NSManaged public var custName: String?
    @NSManaged public var phoneNumber: Int32
    @NSManaged public var custImage: NSData?

}
