//
//  Conversion+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension Conversion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversion> {
        return NSFetchRequest<Conversion>(entityName: "Conversion")
    }

    @NSManaged public var isReversible: Bool
    @NSManaged public var leftValue: Double
    @NSManaged public var rightValue: Double
    @NSManaged public var leftUnit: Unit?
    @NSManaged public var rightUnit: Unit?
    @NSManaged public var symbolName: Symbol?

}
