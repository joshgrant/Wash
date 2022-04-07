//
//  Command+Parsing.swift
//  Wash
//
//  Created by Josh Grant on 4/7/22.
//

import Foundation

extension Command
{
    static func getEntity<T: Entity>(in workspace: [Entity], at index: Int = 0, warn: Bool = true) -> T?
    {
        guard workspace.count > index else
        {
            if warn { print("The index \(index) is out of bounds.") }
            return nil
        }
        
        guard let entity = workspace[index] as? T else
        {
            if warn { print("The entity at index \(index) was not a(n) \(T.self)") }
            return nil
        }
        
        return entity
    }
    
    static func getEntities<A: Entity, B: Entity>(commandData: CommandData, workspace: [Entity], warn: Bool = true) -> (A, B)?
    {
        guard let index = commandData.getIndex() else
        {
            if warn { print("No index.") }
            return nil
        }
        
        let first: A? = getEntity(in: workspace, at: 0, warn: warn)
        let second: B? = getEntity(in: workspace, at: index, warn: warn)
        
        guard let f = first, let s = second else
        {
            return nil
        }
        
        return (f, s)
    }
    
    static func getEntityAndDouble<T: Entity>(commandData: CommandData, workspace: [Entity], warn: Bool = false) -> (T, Double)?
    {
        guard let argument = commandData.arguments.first, let number = Double(argument) else
        {
            if warn { print("Please enter a number.") }
            return nil
        }
        
        guard let entity = workspace.first as? T else
        {
            if warn { print("No entity, or entity isn't a \(T.self)") }
            return nil
        }
        
        return (entity, number)
    }

    static func getEntityAndBool<T: Entity>(commandData: CommandData, workspace: [Entity]) -> (T, Bool)?
    {
        guard let argument = commandData.arguments.first, let bool = Bool(argument) else
        {
            print("Please enter a boolean")
            return nil
        }
        
        guard let entity = workspace.first as? T else
        {
            print("No entity, or entity isn't a \(T.self)")
            return nil
        }
        
        return (entity, bool)
    }
}
