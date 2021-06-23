//
//  Entity+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation
import CoreData
import UIKit
import ProgrammaticUI

public extension Entity
{
    func unwrapped<E, T: Hashable, K: Hashable>(_ keypath: KeyPath<E, T>) -> [K]
    {
        guard let self = self as? E else {
            assertionFailure("Failed to cast self to the correct type: \(E.self)")
            return []
        }
        
        guard let set = self[keyPath: keypath] as? NSSet else {
            assertionFailure("Failed to extract the NSSet from the keypath")
            return []
        }
        
        guard let unwrapped = set as? Set<K> else {
            assertionFailure("Failed to unwrap \(keypath) on the object")
            return []
        }
        
        return Array(unwrapped)
    }
}

public extension Entity
{
    static func makePinnedObjectsPredicate() -> NSPredicate
    {
        NSPredicate(format: "isPinned == %i", true)
    }
    
    static func makePinnedObjectsSortDescriptors() -> [NSSortDescriptor]
    {
        // TODO: Better keypath for sorting..
        [NSSortDescriptor(keyPath: \Entity.id, ascending: false)]
    }
    
    static func makePinnedObjectsFetchRequest() -> NSFetchRequest<Entity>
    {
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        fetchRequest.predicate = makePinnedObjectsPredicate()
        fetchRequest.sortDescriptors = makePinnedObjectsSortDescriptors()
        fetchRequest.shouldRefreshRefetchedObjects = true
        return fetchRequest
    }
}

public extension Entity
{
    func togglePinAction() -> ActionClosure
    {
        ActionClosure { selector in
            self.isPinned.toggle()
        }
    }
}

extension Entity
{
    static var readableName: String
    {
        return entityName.insertSpacesBetweenCamelCaseWords()
    }
    
    static var entityName: String
    {
        let components = NSStringFromClass(self).components(separatedBy: ".")
        
        if let last = components.last
        {
            return last
        }
        else
        {
            assertionFailure("Failed to extract the entity name")
            return ""
        }
    }
    
    static func all<T: Entity>(context: Context) -> [T]
    {
        let request = NSFetchRequest<T>(entityName: entityName)
        do
        {
            return try context.fetch(request)
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
}

// MARK: - Detail Controller

extension Entity
{
    func detailController(navigationController: NavigationController, stateMachine: EntityListStateMachine) -> UIViewController
    {
        switch self
        {
        case (let s as System):
            return SystemDetailController(system: s, navigationController: navigationController, stateMachine: stateMachine)
        case (let s as Stock):
            return StockDetailController(stock: s, navigationController: navigationController)
        case (let t as TransferFlow):
            return TransferFlowDetailController(flow: t, navigationController: navigationController)
        case (let p as ProcessFlow):
            return ProcessFlowDetailController(processFlow: p, navigationController: navigationController)
        case (let e as Event):
            return EventDetailController(event: e, navigationController: navigationController)
        case (let c as Conversion):
            return ConversionDetailController(conversion: c, navigationController: navigationController)
        case (let c as Condition):
            return ConditionDetailController(condition: c, navigationController: navigationController)
        case (let d as Dimension):
            return DimensionDetailController(dimension: d, navigationController: navigationController)
        case (let u as Unit):
            return UnitDetailController(unit: u, navigationController: navigationController)
        case (let s as Symbol):
            return SymbolDetailController(symbol: s, navigationController: navigationController)
        case (let n as Note):
            return NoteDetailController(note: n, navigationController: navigationController)
        default:
            assertionFailure("Unhandled entity: \(self)")
            return UIViewController()
        }
    }
}
