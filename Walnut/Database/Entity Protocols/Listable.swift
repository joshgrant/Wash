//
//  Listable.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import CoreData
import ProgrammaticUI

//protocol Listable: NSManagedObject
//{
////    associatedtype T: Entity, Named = Self
//
//    static var entityName : String { get }
//
//    static func all(context: Context) -> [Self]
//}
//
//extension Listable
//{
//    static var entityName: String
//    {
//        let components = NSStringFromClass(self).components(separatedBy: ".")
//
//        if let last = components.last
//        {
//            return last
//        }
//        else
//        {
//            assertionFailure("Failed to extract the entity name")
//            return ""
//        }
//    }
//
//    static func all(context: Context) -> [Self]
//    {
//        let request = NSFetchRequest<Self>(entityName: entityName)
//        do
//        {
//            return try context.fetch(request)
//        }
//        catch
//        {
//            assertionFailure(error.localizedDescription)
//            return []
//        }
//    }
//}
