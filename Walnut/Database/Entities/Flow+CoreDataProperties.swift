//
//  Flow+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension Flow {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flow> {
        return NSFetchRequest<Flow>(entityName: "Flow")
    }

    @NSManaged public var amount: Double
    @NSManaged public var delay: Double
    @NSManaged public var duration: Double
    @NSManaged public var requiresUserCompletion: Bool
    @NSManaged public var events: NSSet?
    @NSManaged public var from: Stock?
    @NSManaged public var history: NSSet?
    @NSManaged public var symbolName: Symbol?
    @NSManaged public var to: Stock?

}

// MARK: Generated accessors for events
extension Flow {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

// MARK: Generated accessors for history
extension Flow {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: History)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: History)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}
