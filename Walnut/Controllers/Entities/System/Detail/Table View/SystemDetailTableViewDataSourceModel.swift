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
            [], // Stocks
            [], // Flows
            [], // Events
            [], // Subsystems
            [] // Notes
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
}
