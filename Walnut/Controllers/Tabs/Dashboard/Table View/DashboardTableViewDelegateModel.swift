//
//  DashboardTableViewDelegateModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

class DashboardTableViewDelegateModel: TableViewDelegateModel
{
    convenience init(context: Context, navigationController: NavigationController)
    {
        let headerViews = Self.makeHeaderViews()
        let didSelect = Self.makeDidSelect(context: context, navigationController: navigationController)
        
        self.init(
            headerViews: headerViews,
            sectionHeaderHeights: headerViews.count.map { 44 },
            estimatedSectionHeaderHeights: nil,
            didSelect: didSelect)
    }
    
    // MARK: - Factory
    
    static func makeHeaderViews() -> [TableHeaderView]
    {
        // TODO: This should be re-arrangeable in settings
        let headerModels = [
            PinnedHeaderViewModel(),
            FlowsHeaderViewModel(),
            ForecastHeaderViewModel(),
            PriorityHeaderViewModel()
        ]
        
        return headerModels.map { TableHeaderView(model: $0) }
    }
    
    static func makeDidSelect(context: Context, navigationController: NavigationController) -> TableViewSelectionClosure
    {
        { selection in
            switch selection.indexPath.section
            {
            // Pinned objects
            case 0:
                // TODO: This is bad, need to fix
                let pins = DashboardTableViewDataSourceModel.getPinnedObjects(context: context)
            // open the detail view...
                let pin = pins[selection.indexPath.row]
                let detail = pin.detailController(navigationController: navigationController)
                navigationController.pushViewController(detail, animated: true)
            case 1:
                break
            case 2:
                break
            case 3:
                break
            default:
                assertionFailure("Unhandled section")
            }
        }
    }
}
