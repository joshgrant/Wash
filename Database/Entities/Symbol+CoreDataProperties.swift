//
//  Symbol+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension Symbol {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Symbol> {
        return NSFetchRequest<Symbol>(entityName: "Symbol")
    }

    @NSManaged public var name: String?
    @NSManaged public var linkedEntities: NSSet?
    @NSManaged public var nameOfColor: Color?
    @NSManaged public var nameOfCondition: Condition?
    @NSManaged public var nameOfConversion: Conversion?
    @NSManaged public var nameOfEvent: Event?
    @NSManaged public var nameOfFlow: Flow?
    @NSManaged public var nameOfState: State?
    @NSManaged public var nameOfStock: Stock?
    @NSManaged public var nameOfTask: Task?
    @NSManaged public var nameOfUnit: Unit?

}

// MARK: Generated accessors for linkedEntities
extension Symbol {

    @objc(addLinkedEntitiesObject:)
    @NSManaged public func addToLinkedEntities(_ value: Entity)

    @objc(removeLinkedEntitiesObject:)
    @NSManaged public func removeFromLinkedEntities(_ value: Entity)

    @objc(addLinkedEntities:)
    @NSManaged public func addToLinkedEntities(_ values: NSSet)

    @objc(removeLinkedEntities:)
    @NSManaged public func removeFromLinkedEntities(_ values: NSSet)

}
