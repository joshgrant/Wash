//
//  Condition+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension Condition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Condition> {
        return NSFetchRequest<Condition>(entityName: "Condition")
    }

    @NSManaged public var booleanComparisonTypeRaw: Int16
    @NSManaged public var dateComparisonTypeRaw: Int16
    @NSManaged public var numberComparisonTypeRaw: Int16
    @NSManaged public var priorityTypeRaw: Int16
    @NSManaged public var stringComparisonTypeRaw: Int16
    @NSManaged public var events: NSSet?
    @NSManaged public var leftHand: Source?
    @NSManaged public var rightHand: Source?
    @NSManaged public var symbolName: Symbol?

}

// MARK: Generated accessors for events
extension Condition {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
