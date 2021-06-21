//
//  SystemDetailTableViewDataSourceModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import ProgrammaticUI

class SystemDetailTableViewDataSourceModel: TableViewDataSourceModel
{
    // MARK: - Initialization
    
    convenience init(system: System)
    {
        let cellModels = Self.makeCellModels(system: system)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(system: System) -> [[TableViewCellModel]]
    {
        [
            // Info
            makeInfoSection(system: system),
            makeStocksModels(system: system),
            makeFlowsModels(system: system),
            makeEventsModels(system: system),
//            [], // Subsystems
            makeNotesModels(system: system)
        ]
    }
    
    static func makeInfoSection(system: System) -> [TableViewCellModel]
    {
        var section: [TableViewCellModel] = []
        
        section.append(TextEditCellModel(
                        text: system.title,
                        placeholder: "Name"))
        
        section.append(IdealInfoCellModel(
                        percentage: system.percentIdeal,
                        infoAction: nil))
        
        //        if let flow = system.suggestedFlow
        //        {
        //            section.append(SuggestedFlowCellModel(title: flow.title))
        //        }
        
        return section
    }
    
    static func makeStocksModels(system: System) -> [TableViewCellModel]
    {
        let stocks = system.unwrappedStocks
        return stocks.map
        {
            DetailCellModel(title: $0.title, detail: $0.currentDescription)
        }
    }
    
    static func makeFlowsModels(system: System) -> [TableViewCellModel]
    {
        let flows = system.unwrappedFlows
        return flows.map
        {
            DetailCellModel(title: $0.title, detail: "None")
        }
    }
    
    static func makeEventsModels(system: System) -> [TableViewCellModel]
    {
        let events = system.unwrappedEvents
        return events.map
        {
            DetailCellModel(title: $0.title, detail: "None")
        }
    }
    
    static func makeNotesModels(system: System) -> [TableViewCellModel]
    {
        let notes = system.unwrappedNotes
        return notes.map
        {
            DetailCellModel(title: $0.title, detail: $0.firstLine ?? "None")
        }
    }
}
