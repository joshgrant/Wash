//
//  EntityListTableViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

//import Foundation
import ProgrammaticUI

class EntityListTableViewDelegateModel<E: LibraryVisible>: TableViewDelegateModel
{
    // MARK: - Initialization
    
    convenience init(context: Context, navigationController: NavigationController)
    {
        let didSelect = Self.makeDidSelect(
            context: context,
            navigationController: navigationController)
        
        self.init(
            headerViews: nil,
            sectionHeaderHeights: nil,
            estimatedSectionHeaderHeights: nil,
            didSelect: didSelect)
    }
    
    // MARK: - Factory
    
    static func makeDidSelect(context: Context, navigationController: NavigationController) -> TableViewSelectionClosure
    {
        { selection in
            //
            let all = E.all(context: context)
            let entity = all[selection.indexPath.row]
            print("Selected: \(entity)")
            // TODO: Get the detail controller
            // TODO: push the detail controller
        }
    }
}

class EntityListTableViewDataSourceModel<E: LibraryVisible>: TableViewDataSourceModel
{
    // MARK: - Initialization
    
    convenience init(context: Context)
    {
        let cellModels = Self.makeCellModels(context: context)
        self.init(cellModels: cellModels)
    }
    
    // MARK: - Factory
    
    static func makeCellModels(context: Context) -> [[TableViewCellModel]]
    {
        [
            makeEntityListCellModels(context: context)
        ]
    }
    
    static func makeEntityListCellModels(context: Context) -> [TableViewCellModel]
    {
        E.all(context: context).map
        {
            TextCellModel(title: $0.title)
        }
    }
}


class EntityListTableViewModel<E: LibraryVisible>: TableViewModel<
                                                                            EntityListTableViewDelegateModel<E>,
                                                                            EntityListTableViewDataSourceModel<E>>
{
    // MARK: - Initialization
    
    convenience init(context: Context, navigationController: NavigationController)
    {
        let delegateModel = EntityListTableViewDelegateModel<E>(
            context: context,
            navigationController: navigationController)
        let dataSourceModel = EntityListTableViewDataSourceModel<E>(
            context: context)
        let cellModelTypes = Self.makeCellModelTypes()
        
        self.init(
            style: .grouped,
            delegateModel: delegateModel,
            dataSourceModel: dataSourceModel,
            cellModelTypes: cellModelTypes)
    }
    
    // MARK: - Factory
    
    static func makeCellModelTypes() -> [TableViewCellModel.Type]
    {
        [
            TextCellModel.self
        ]
    }
}
