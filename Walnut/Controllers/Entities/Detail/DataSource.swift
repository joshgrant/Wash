//
//  DataSource.swift
//  Walnut
//
//  Created by Josh Grant on 1/27/22.
//

import Foundation
import Protyper

extension EntityDetailViewController {
    struct DataSource
    {
        var dataProvider: (Entity) -> [Section: [Row]]
        var commandHandler: ((Command) -> Void)? = nil
    }
}

extension EntityDetailViewController.DataSource
{
    typealias Configuration = EntityDetailViewController.DataSource
    typealias Section = EntityDetailViewController.Section
    typealias Row = EntityDetailViewController.Row
    
    static let condition = Configuration { _ in
        return [:]
    }
    
    static let conversion = Configuration { _ in
        return [:]
    }
    
    static let event = Configuration { entity in
        guard let event = entity as? Event else { return [:] }
        
        var configuration: [Section: [Row]] = [:]
        
        configuration[.info] = [
            .editable(index: 0, text: event.title, placeholder: "Title"),
            .toggle(index: 1, text: "Active", isOn: event.isActive)
        ]
        
        let conditions: [Condition] = event.unwrapped(\Event.conditions)
        configuration[.conditions] = conditions.enumerated().map {
            let index = $0.offset
            let text = $0.element.title
            return .detail(index: index, text: text)
        }
        return configuration
    }
    
    static let note = Configuration { _ in
        return [:]
    }
    
    static let flow = Configuration { entity in
        guard let flow = entity as? Flow else { return [:] }
        
        var configuration: [Section: [Row]] = [:]
        
        configuration[.info] = [
            .detail(index: 0, text: "From: \(flow.from?.title ?? "")"),
            .detail(index: 1, text: "To: \(flow.to?.title ?? "")")
        ]
        
        return configuration
    }
    
    static let stock = Configuration { entity in
        guard let stock = entity as? Stock else { return [:] }
        
        var configuration: [Section: [Row]] = [:]
        
        if stock.uniqueID == ContextPopulator.sinkId || stock.uniqueID == ContextPopulator.sourceId
        {
            configuration[.info] = [.text(string: "Value: Infinity")]
        }
        else
        {
            let current = String(format: "%.2f", stock.current)
            let target = String(format: "%.2f", stock.target)
            let currentText = "Current: \(current)"
            let targetText = "Target: \(target)"
            configuration[.info] = [
                .text(string: "Current: \(current)"),
                .text(string: "Target: \(target)")
            ]
        }
        
        configuration[.states] = []
        configuration[.inflows] = stock.unwrappedInflows.enumerated().map({
            .flow(index: $0.offset, flow: $0.element)
        })
        configuration[.outflows] = stock.unwrappedOutflows.enumerated().map {
            .flow(index: $0.offset, flow: $0.element)
        }
        configuration[.notes] = stock.unwrapped(\Stock.notes).enumerated().map {
            .note(index: $0.offset, note: $0.element)
        }
        return configuration
    }
    
    static let symbol = Configuration { _ in
        return [:]
    }
    
    static let task = Configuration { _ in
        return [:]
    }
    
    static let unit = Configuration { entity in
        guard let unit = entity as? Unit else { return [:] }
        
        var configuration: [Section: [Row]] = [:]
        configuration[.info] = [
            .editable(index: 0, text: unit.title, placeholder: "Title"),
            .editable(index: 1, text: unit.abbreviation, placeholder: "Abbreviation"),
            .keyValue(key: "Is Base", value: unit.isBase ? "Yes" : "No")
        ]
        
        if !unit.isBase
        {
            configuration[.info]?.append(.keyValue(key: "Relative To", value: unit.parent?.title ?? "None"))
        }
        return configuration
    }
}
