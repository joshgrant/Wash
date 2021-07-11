//
//  LibraryTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation

class LibraryTableView: TableView
{
    // MARK: - Variables
    
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(context: Context?)
    {
        self.context = context
        super.init()
    }
    
    // MARK: - Model
    
    override func makeModel() -> TableViewModel
    {
        guard let context = context else {
            fatalError()
        }
        
        let models = EntityType.libraryVisible.map { entityType in
            LibraryCellModel(selectionIdentifier: .entityType(type: entityType),
                             entityType: entityType,
                             context: context)
        }
        
        return TableViewModel(sections: [
            TableViewSection(models: models)
        ])
    }
}
