//
//  Color+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension Color {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Color> {
        return NSFetchRequest<Color>(entityName: "Color")
    }

    @NSManaged public var brightness: Double
    @NSManaged public var hue: Double
    @NSManaged public var saturation: Double
    @NSManaged public var backgroundColorOf: NSSet?
    @NSManaged public var mainColorOf: NSSet?
    @NSManaged public var symbolName: Symbol?
    @NSManaged public var text: Block?
    @NSManaged public var tintColorOf: NSSet?

}

// MARK: Generated accessors for backgroundColorOf
extension Color {

    @objc(addBackgroundColorOfObject:)
    @NSManaged public func addToBackgroundColorOf(_ value: Block)

    @objc(removeBackgroundColorOfObject:)
    @NSManaged public func removeFromBackgroundColorOf(_ value: Block)

    @objc(addBackgroundColorOf:)
    @NSManaged public func addToBackgroundColorOf(_ values: NSSet)

    @objc(removeBackgroundColorOf:)
    @NSManaged public func removeFromBackgroundColorOf(_ values: NSSet)

}

// MARK: Generated accessors for mainColorOf
extension Color {

    @objc(addMainColorOfObject:)
    @NSManaged public func addToMainColorOf(_ value: Block)

    @objc(removeMainColorOfObject:)
    @NSManaged public func removeFromMainColorOf(_ value: Block)

    @objc(addMainColorOf:)
    @NSManaged public func addToMainColorOf(_ values: NSSet)

    @objc(removeMainColorOf:)
    @NSManaged public func removeFromMainColorOf(_ values: NSSet)

}

// MARK: Generated accessors for tintColorOf
extension Color {

    @objc(addTintColorOfObject:)
    @NSManaged public func addToTintColorOf(_ value: Block)

    @objc(removeTintColorOfObject:)
    @NSManaged public func removeFromTintColorOf(_ value: Block)

    @objc(addTintColorOf:)
    @NSManaged public func addToTintColorOf(_ values: NSSet)

    @objc(removeTintColorOf:)
    @NSManaged public func removeFromTintColorOf(_ values: NSSet)

}
