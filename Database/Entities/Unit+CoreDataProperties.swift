//
//  Unit+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension Unit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Unit> {
        return NSFetchRequest<Unit>(entityName: "Unit")
    }

    @NSManaged public var abbreviation: String?
    @NSManaged public var isBase: Bool
    @NSManaged public var children: NSSet?
    @NSManaged public var conversionLeft: Conversion?
    @NSManaged public var conversionRight: Conversion?
    @NSManaged public var parent: Unit?
    @NSManaged public var stocks: NSSet?
    @NSManaged public var symbolName: Symbol?

}

// MARK: Generated accessors for children
extension Unit {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: Unit)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: Unit)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}

// MARK: Generated accessors for stocks
extension Unit {

    @objc(addStocksObject:)
    @NSManaged public func addToStocks(_ value: Stock)

    @objc(removeStocksObject:)
    @NSManaged public func removeFromStocks(_ value: Stock)

    @objc(addStocks:)
    @NSManaged public func addToStocks(_ values: NSSet)

    @objc(removeStocks:)
    @NSManaged public func removeFromStocks(_ values: NSSet)

}
