//
//  Source+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension Source {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Source> {
        return NSFetchRequest<Source>(entityName: "Source")
    }

    @NSManaged public var value: Double
    @NSManaged public var valueTypeRaw: Int16
    @NSManaged public var conditionLeftHand: Condition?
    @NSManaged public var conditionRightHand: Condition?
    @NSManaged public var dynamicSource: Source?
    @NSManaged public var history: History?
    @NSManaged public var linkedSources: NSSet?
    @NSManaged public var stock: Stock?
    @NSManaged public var stockIdeal: Stock?
    @NSManaged public var stockMaximum: Stock?
    @NSManaged public var stockMinimum: Stock?

}

// MARK: Generated accessors for linkedSources
extension Source {

    @objc(addLinkedSourcesObject:)
    @NSManaged public func addToLinkedSources(_ value: Source)

    @objc(removeLinkedSourcesObject:)
    @NSManaged public func removeFromLinkedSources(_ value: Source)

    @objc(addLinkedSources:)
    @NSManaged public func addToLinkedSources(_ values: NSSet)

    @objc(removeLinkedSources:)
    @NSManaged public func removeFromLinkedSources(_ values: NSSet)

}
