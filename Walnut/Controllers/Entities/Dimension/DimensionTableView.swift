//
//  DimensionTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation

class DimensionTableView: TableView
{
    // MARK: - Variables
    
    var dimension: Dimension
    
    // MARK: - Initialization
    
    init(dimension: Dimension)
    {
        self.dimension = dimension
//        Foundation.Dimension.baseUnit()
        super.init()
    }
    
    // MARK: - Functions
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            TableViewSection(models: [
                TextEditCellModel(
                    selectionIdentifier: .title,
                    text: dimension.title,
                    placeholder: "Title".localized,
                    entity: dimension)
//                ToggleCellModel(
//                    selectionIdentifier: .baseUnit(isOn: dimension.parent == nil),
//                    title: "Base Unit".localized,
//                    toggleState: dimension.isBase),
//                DetailCellModel(
//                    selectionIdentifier: .relativeTo,
//                    title: "Relative To".localized,
//                    detail: dimension.parent,
//                    disclosure: false)
            ])
        ])
    }
}
