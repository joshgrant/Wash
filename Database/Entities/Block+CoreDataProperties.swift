//
//  Block+CoreDataProperties.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//
//

import Foundation
import CoreData


extension Block {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Block> {
        return NSFetchRequest<Block>(entityName: "Block")
    }

    @NSManaged public var imageCaption: String?
    @NSManaged public var imageURL: URL?
    @NSManaged public var tableData: Data?
    @NSManaged public var text: String?
    @NSManaged public var textSizeTypeRaw: Int16
    @NSManaged public var textStyleTypeRaw: Int16
    @NSManaged public var url: URL?
    @NSManaged public var backgroundColor: Color?
    @NSManaged public var mainColor: Color?
    @NSManaged public var note: Note?
    @NSManaged public var textColor: Color?
    @NSManaged public var tintColor: Color?

}
