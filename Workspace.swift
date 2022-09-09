//
//  Workspace.swift
//  Wash
//
//  Created by Joshua Grant on 9/8/22.
//

import Foundation

class Workspace
{
    // MARK: - Variables
    
    var source: Stock
    var sink: Stock
    
    var year: Stock
    var month: Stock
    var day: Stock
    var hour: Stock
    var minute: Stock
    var second: Stock
    
    var entities: [Entity]
    
    var lastResult: [Entity]
    
    // MARK: - Initialization
    
    init(database: Database)
    {
        source = ContextPopulator.sourceStock(context: database.context)
        sink = ContextPopulator.sinkStock(context: database.context)
        
        year = ContextPopulator.yearStock(context: database.context)
        month = ContextPopulator.monthStock(context: database.context)
        day = ContextPopulator.dayStock(context: database.context)
        hour = ContextPopulator.hourStock(context: database.context)
        minute = ContextPopulator.minuteStock(context: database.context)
        second = ContextPopulator.secondStock(context: database.context)
        
        entities = [source, sink]
        lastResult = []
    }
    
    // MARK: - Functions
    
    func first<T>() throws -> T
    {
        guard let first = entities.first else
        {
            throw ParsingError.workspaceHasNoEntities
        }
        
        guard let first = first as? T else
        {
            throw ParsingError.workspaceFirstEntityIsNot(T.self)
        }
        
        return first
    }
    
    func entity<T>(at index: Int) throws -> T
    {
        guard entities.count > index else
        {
            throw ParsingError.indexOutsideOfArgumentsBounds(index)
        }
        
        guard let entity = entities[index] as? T else
        {
            throw ParsingError.argumentDidNotMatchType(T.self)
        }
        
        return entity
    }
    
    func update()
    {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: .now)
        year.current = Double(components.year ?? 0)
        month.current = Double(components.month ?? 0)
        day.current = Double(components.day ?? 0)
        hour.current = Double(components.hour ?? 0)
        minute.current = Double(components.minute ?? 0)
        second.current = Double(components.second ?? 0)
    }
    
    func display()
    {
        print(entities.formatted(EntityListFormatStyle()))
    }
}
