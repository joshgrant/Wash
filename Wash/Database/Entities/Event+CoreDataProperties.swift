//
//  Event+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var conditionTypeRaw: Int16
    @NSManaged public var isActive: Bool
    @NSManaged public var conditions: NSSet?
    @NSManaged public var flows: NSSet?
    @NSManaged public var history: NSSet?
    @NSManaged public var stocks: NSSet?
    @NSManaged public var symbolName: Symbol?

}

// MARK: Generated accessors for conditions
extension Event {

    @objc(addConditionsObject:)
    @NSManaged public func addToConditions(_ value: Condition)

    @objc(removeConditionsObject:)
    @NSManaged public func removeFromConditions(_ value: Condition)

    @objc(addConditions:)
    @NSManaged public func addToConditions(_ values: NSSet)

    @objc(removeConditions:)
    @NSManaged public func removeFromConditions(_ values: NSSet)

}

// MARK: Generated accessors for flows
extension Event {

    @objc(addFlowsObject:)
    @NSManaged public func addToFlows(_ value: Flow)

    @objc(removeFlowsObject:)
    @NSManaged public func removeFromFlows(_ value: Flow)

    @objc(addFlows:)
    @NSManaged public func addToFlows(_ values: NSSet)

    @objc(removeFlows:)
    @NSManaged public func removeFromFlows(_ values: NSSet)

}

// MARK: Generated accessors for history
extension Event {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: History)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: History)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}

// MARK: Generated accessors for stocks
extension Event {

    @objc(addStocksObject:)
    @NSManaged public func addToStocks(_ value: Stock)

    @objc(removeStocksObject:)
    @NSManaged public func removeFromStocks(_ value: Stock)

    @objc(addStocks:)
    @NSManaged public func addToStocks(_ values: NSSet)

    @objc(removeStocks:)
    @NSManaged public func removeFromStocks(_ values: NSSet)

}
