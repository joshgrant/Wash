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
        super.init()
    }
    
    // MARK: - Functions
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            TableViewSection(
                header: .info,
                models: [
                    TextEditCellModel(
                        selectionIdentifier: .title,
                        text: dimension.title,
                        placeholder: "Title".localized,
                        entity: dimension)
                ])
        ])
    }
}
