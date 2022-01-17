//
//  Entity+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var deletedDate: Date?
    @NSManaged public var isHidden: Bool
    @NSManaged public var isPinned: Bool
    @NSManaged public var uniqueID: UUID?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var notes: NSSet?
    @NSManaged public var symbols: NSSet?

}

// MARK: Generated accessors for notes
extension Entity {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

// MARK: Generated accessors for symbols
extension Entity {

    @objc(addSymbolsObject:)
    @NSManaged public func addToSymbols(_ value: Symbol)

    @objc(removeSymbolsObject:)
    @NSManaged public func removeFromSymbols(_ value: Symbol)

    @objc(addSymbols:)
    @NSManaged public func addToSymbols(_ values: NSSet)

    @objc(removeSymbols:)
    @NSManaged public func removeFromSymbols(_ values: NSSet)

}

extension Entity : Identifiable {

}
