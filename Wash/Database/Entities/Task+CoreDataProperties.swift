//
//  Task+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var completionOrderTypeRaw: Int16
    @NSManaged public var completionTypeRaw: Int16
    @NSManaged public var secondaryText: String?
    @NSManaged public var sortOrder: Int32
    @NSManaged public var text: String?
    @NSManaged public var parent: Task?
    @NSManaged public var producedStocks: NSSet?
    @NSManaged public var requiredStocks: NSSet?
    @NSManaged public var subtasks: NSSet?
    @NSManaged public var symbolName: Symbol?

}

// MARK: Generated accessors for producedStocks
extension Task {

    @objc(addProducedStocksObject:)
    @NSManaged public func addToProducedStocks(_ value: Stock)

    @objc(removeProducedStocksObject:)
    @NSManaged public func removeFromProducedStocks(_ value: Stock)

    @objc(addProducedStocks:)
    @NSManaged public func addToProducedStocks(_ values: NSSet)

    @objc(removeProducedStocks:)
    @NSManaged public func removeFromProducedStocks(_ values: NSSet)

}

// MARK: Generated accessors for requiredStocks
extension Task {

    @objc(addRequiredStocksObject:)
    @NSManaged public func addToRequiredStocks(_ value: Stock)

    @objc(removeRequiredStocksObject:)
    @NSManaged public func removeFromRequiredStocks(_ value: Stock)

    @objc(addRequiredStocks:)
    @NSManaged public func addToRequiredStocks(_ values: NSSet)

    @objc(removeRequiredStocks:)
    @NSManaged public func removeFromRequiredStocks(_ values: NSSet)

}

// MARK: Generated accessors for subtasks
extension Task {

    @objc(addSubtasksObject:)
    @NSManaged public func addToSubtasks(_ value: Task)

    @objc(removeSubtasksObject:)
    @NSManaged public func removeFromSubtasks(_ value: Task)

    @objc(addSubtasks:)
    @NSManaged public func addToSubtasks(_ values: NSSet)

    @objc(removeSubtasks:)
    @NSManaged public func removeFromSubtasks(_ values: NSSet)

}
