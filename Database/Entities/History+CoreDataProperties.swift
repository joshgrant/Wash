//
//  History+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var date: Date?
    @NSManaged public var eventTypeRaw: Int16
    @NSManaged public var historyOfEvent: Event?
    @NSManaged public var historyOfFlow: Flow?
    @NSManaged public var historyOfStock: Stock?
    @NSManaged public var source: Source?

}
