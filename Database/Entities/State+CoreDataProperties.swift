//
//  State+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension State {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<State> {
        return NSFetchRequest<State>(entityName: "State")
    }

    @NSManaged public var max: Double
    @NSManaged public var min: Double
    @NSManaged public var stocks: NSSet?
    @NSManaged public var symbolName: Symbol?

}

// MARK: Generated accessors for stocks
extension State {

    @objc(addStocksObject:)
    @NSManaged public func addToStocks(_ value: Stock)

    @objc(removeStocksObject:)
    @NSManaged public func removeFromStocks(_ value: Stock)

    @objc(addStocks:)
    @NSManaged public func addToStocks(_ values: NSSet)

    @objc(removeStocks:)
    @NSManaged public func removeFromStocks(_ values: NSSet)

}
