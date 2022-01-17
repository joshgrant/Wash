//
//  Stock+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }

    @NSManaged public var stateMachine: Bool
    @NSManaged public var events: NSSet?
    @NSManaged public var history: NSSet?
    @NSManaged public var ideal: Source?
    @NSManaged public var inflows: NSSet?
    @NSManaged public var maximum: Source?
    @NSManaged public var minimum: Source?
    @NSManaged public var outflows: NSSet?
    @NSManaged public var producedStockOfProcesss: Task?
    @NSManaged public var requiredStockOfProcesss: NSSet?
    @NSManaged public var source: Source?
    @NSManaged public var symbolName: Symbol?
    @NSManaged public var unit: Unit?
    @NSManaged public var validStates: NSSet?

}

// MARK: Generated accessors for events
extension Stock {

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
extension Stock {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: History)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: History)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}

// MARK: Generated accessors for inflows
extension Stock {

    @objc(addInflowsObject:)
    @NSManaged public func addToInflows(_ value: Flow)

    @objc(removeInflowsObject:)
    @NSManaged public func removeFromInflows(_ value: Flow)

    @objc(addInflows:)
    @NSManaged public func addToInflows(_ values: NSSet)

    @objc(removeInflows:)
    @NSManaged public func removeFromInflows(_ values: NSSet)

}

// MARK: Generated accessors for outflows
extension Stock {

    @objc(addOutflowsObject:)
    @NSManaged public func addToOutflows(_ value: Flow)

    @objc(removeOutflowsObject:)
    @NSManaged public func removeFromOutflows(_ value: Flow)

    @objc(addOutflows:)
    @NSManaged public func addToOutflows(_ values: NSSet)

    @objc(removeOutflows:)
    @NSManaged public func removeFromOutflows(_ values: NSSet)

}

// MARK: Generated accessors for requiredStockOfProcesss
extension Stock {

    @objc(addRequiredStockOfProcesssObject:)
    @NSManaged public func addToRequiredStockOfProcesss(_ value: Task)

    @objc(removeRequiredStockOfProcesssObject:)
    @NSManaged public func removeFromRequiredStockOfProcesss(_ value: Task)

    @objc(addRequiredStockOfProcesss:)
    @NSManaged public func addToRequiredStockOfProcesss(_ values: NSSet)

    @objc(removeRequiredStockOfProcesss:)
    @NSManaged public func removeFromRequiredStockOfProcesss(_ values: NSSet)

}

// MARK: Generated accessors for validStates
extension Stock {

    @objc(addValidStatesObject:)
    @NSManaged public func addToValidStates(_ value: State)

    @objc(removeValidStatesObject:)
    @NSManaged public func removeFromValidStates(_ value: State)

    @objc(addValidStates:)
    @NSManaged public func addToValidStates(_ values: NSSet)

    @objc(removeValidStates:)
    @NSManaged public func removeFromValidStates(_ values: NSSet)

}
