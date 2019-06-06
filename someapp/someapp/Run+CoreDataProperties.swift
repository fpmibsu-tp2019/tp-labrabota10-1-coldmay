//
//  Run+CoreDataProperties.swift
//  someapp
//
//  Created by User on 04/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//
//

import Foundation
import CoreData


extension Run {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Run> {
        return NSFetchRequest<Run>(entityName: "Run")
    }

    @NSManaged public var distance: Double
    @NSManaged public var duration: Int32
    @NSManaged public var calories: Int32
    @NSManaged public var speed: Double
    @NSManaged public var date: NSDate?

}
