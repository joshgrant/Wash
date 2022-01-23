//
//  EntityDetailViewController.swift
//  Walnut
//
//  Created by Joshua Grant on 1/22/22.
//

import Foundation
import Protyper

enum Section: Int, Comparable, CustomStringConvertible
{
    case info
    case states
    case inflows
    case outflows
    case notes
    case events
    case history
    case conditions
    case flows
    case references
    case links
    
    static func < (lhs: Section, rhs: Section) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var description: String
    {
        switch self
        {
        case .info:
            return "Info"
        case .states:
            return "\(Icon.state.text) States"
        case .inflows:
            return "\(Icon.leftArrow.text) Inflows"
        case .outflows:
            return "\(Icon.rightArrow.text) Outflows"
        case .notes:
            return "\(Icon.note.text) Notes"
        case .events:
            return "\(Icon.event.text) Events"
        case .history:
            return "\(Icon.forecast.text) History"
        case .conditions:
            return "\(Icon.condition.text) Conditions"
        case .flows:
            return "\(Icon.flow.text) Flows"
        case .references:
            return "References"
        case .links:
            return "Links"
        }
    }
}

enum Row: CustomStringConvertible
{
    case text(string: String)
    case detail(index: Int, text: String)
    case flow(index: Int, flow: Flow)
    case note(index: Int, note: Note)
    case keyValue(key: String, value: String)
    
    var description: String
    {
        switch self {
        case .text(let string):
            return string
        case .detail(let index, let text):
            return "\(index). \(text)"
        case .flow(let index, let flow):
            // TODO: Why is to/from flipped here???
            return " \(index). \(flow.title): \(flow.to?.title ?? "None") -> \(flow.from?.title ?? "None") (\(String(format: "%.2f", flow.amount)))"
        case .note(let index, let note):
            return " \(index). \(note.firstLine ?? "")\n    \(note.secondLine ?? "")"
        case .keyValue(let key, let value):
            return "\(key): \(value)"
        }
    }
}

/// The detail view controller is responsible for showing all of the different
/// entity details. They have a configuration (which sections they want)
/// as well as information on how to access the data in those sections. Because
/// a lof of sections are reused (notes, for example) this reduces some duplication
class EntityDetailViewController: ViewController
{
    var entity: Named
    var configuration: Configuration
    
    init(entity: Named, configuration: Configuration)
    {
        self.entity = entity
        self.configuration = configuration
        super.init(title: entity.title, view: nil)
    }
    
    override func display()
    {
        let data = configuration.dataProvider(entity).sorted { $0.key < $1.key }
        for item in data.enumerated()
        {
            let index = item.offset + 1
            let section = item.element.key
            let rows = item.element.value
            
            print("\(index). \(section)")
            print("   —–––")
            for row in rows
            {
                print(row)
            }
            print("")
        }
    }
}

struct Configuration
{
    var dataProvider: (Entity) -> [Section: [Row]]
    var commandHandler: ((Command) -> Void)? = nil
    
    static func configuration(for entity: Entity) -> Configuration
    {
        switch entity
        {
        case is Stock: return .stock
        case is Flow: return .flow
        case is Task: return .task
        case is Event: return .event
        case is Conversion: return .conversion
        case is Condition: return .condition
        case is Symbol: return .symbol
        case is Note: return .note
        case is Unit: return .unit
        default:
            fatalError("Unhandled entity")
        }
    }
}

extension Configuration
{
    static let condition = Configuration { _ in
        return [:]
    }
    
    static let conversion = Configuration { _ in
        return [:]
    }
    
    static let event = Configuration { _ in
        return [:]
    }
    
    static let note = Configuration { _ in
        return [:]
    }
    
    static let flow = Configuration { entity in
        guard let flow = entity as? Flow else { return [:] }
        
        var configuration: [Section: [Row]] = [:]
        
        configuration[.info] = [
            .detail(index: 1, text: "From: \(flow.from?.title ?? "")"),
            .detail(index: 2, text: "To: \(flow.to?.title ?? "")")
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
            .flow(index: $0.offset + 1, flow: $0.element)
        })
        configuration[.outflows] = stock.unwrappedOutflows.enumerated().map {
            .flow(index: $0.offset + 1, flow: $0.element)
        }
        configuration[.notes] = stock.unwrapped(\Stock.notes).enumerated().map {
            .note(index: $0.offset + 1, note: $0.element)
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
            .keyValue(key: "Title", value: unit.title),
            .keyValue(key: "Abbreviation", value: unit.abbreviation ?? "None"),
            .keyValue(key: "Is Base", value: unit.isBase ? "Yes" : "No")
        ]
        
        if !unit.isBase
        {
            configuration[.info]?.append(.keyValue(key: "Relative To", value: unit.parent?.title ?? "None"))
        }
        return configuration
    }
}
