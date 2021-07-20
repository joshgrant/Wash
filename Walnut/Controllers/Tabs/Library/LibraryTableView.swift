//
//  LibraryTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

protocol LibraryTableViewFactory: Factory
{
    func makeModel() -> TableViewModel
}

class LibraryTableViewContainer: TableViewDependencyContainer
{
    // MARK: - Variables
    
    var context: Context
    var stream: Stream
    var style: UITableView.Style
    
    lazy var model: TableViewModel = makeModel()
    
    // MARK: - Initialization
    
    init(context: Context, stream: Stream, style: UITableView.Style)
    {
        self.context = context
        self.stream = stream
        self.style = style
    }
}

extension LibraryTableViewContainer: LibraryTableViewFactory
{
    func makeModel() -> TableViewModel
    {        
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
