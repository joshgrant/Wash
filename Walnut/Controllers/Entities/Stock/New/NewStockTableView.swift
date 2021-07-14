//
//  NewStockTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/13/21.
//

import Foundation

enum NewStockType
{
    case boolean
    case integer
    case decimal
    case percent
}

class NewStockTableView: TableView
{
    var title: String?
    var unit: Unit?
    var stockType = NewStockType.boolean
    var isStateMachine: Bool = false
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection(),
            makeValueTypeSection(),
            makeStateMachineSection()
        ])
    }
    
    func makeInfoSection() -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            TextEditCellModel(
                selectionIdentifier: .title,
                text: title,
                placeholder: "Title".localized,
                entity: nil),
            DetailCellModel(
                selectionIdentifier: .newStockUnit,
                title: "Unit".localized,
                detail: unit.title ?? "None".localized,
                disclosure: true)
            
        ]
        
        return TableViewSection(
            header: .info,
            models: models)
    }
    
    func makeValueTypeSection() -> TableViewSection
    {
        
    }
    
    func makeStateMachineSection() -> TableViewSection
    {
        
    }
}
