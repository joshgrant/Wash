//
//  Note+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var thumbnail: URL?
    @NSManaged public var blocks: NSSet?
    @NSManaged public var linkedEntities: NSSet?
    @NSManaged public var parent: Note?
    @NSManaged public var relatedNotes: NSSet?
    @NSManaged public var subnotes: NSSet?

}

// MARK: Generated accessors for blocks
extension Note {

    @objc(addBlocksObject:)
    @NSManaged public func addToBlocks(_ value: Block)

    @objc(removeBlocksObject:)
    @NSManaged public func removeFromBlocks(_ value: Block)

    @objc(addBlocks:)
    @NSManaged public func addToBlocks(_ values: NSSet)

    @objc(removeBlocks:)
    @NSManaged public func removeFromBlocks(_ values: NSSet)

}

// MARK: Generated accessors for linkedEntities
extension Note {

    @objc(addLinkedEntitiesObject:)
    @NSManaged public func addToLinkedEntities(_ value: Entity)

    @objc(removeLinkedEntitiesObject:)
    @NSManaged public func removeFromLinkedEntities(_ value: Entity)

    @objc(addLinkedEntities:)
    @NSManaged public func addToLinkedEntities(_ values: NSSet)

    @objc(removeLinkedEntities:)
    @NSManaged public func removeFromLinkedEntities(_ values: NSSet)

}

// MARK: Generated accessors for relatedNotes
extension Note {

    @objc(addRelatedNotesObject:)
    @NSManaged public func addToRelatedNotes(_ value: Note)

    @objc(removeRelatedNotesObject:)
    @NSManaged public func removeFromRelatedNotes(_ value: Note)

    @objc(addRelatedNotes:)
    @NSManaged public func addToRelatedNotes(_ values: NSSet)

    @objc(removeRelatedNotes:)
    @NSManaged public func removeFromRelatedNotes(_ values: NSSet)

}

// MARK: Generated accessors for subnotes
extension Note {

    @objc(addSubnotesObject:)
    @NSManaged public func addToSubnotes(_ value: Note)

    @objc(removeSubnotesObject:)
    @NSManaged public func removeFromSubnotes(_ value: Note)

    @objc(addSubnotes:)
    @NSManaged public func addToSubnotes(_ values: NSSet)

    @objc(removeSubnotes:)
    @NSManaged public func removeFromSubnotes(_ values: NSSet)

}
