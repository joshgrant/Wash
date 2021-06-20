//
//  DashboardControllerModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit
import CoreData
import ProgrammaticUI

class DashboardControllerModel: ControllerModel
{
}

// MARK: - Tab Bar

extension DashboardControllerModel: ControllerModelTabBarDelegate
{
    var tabBarItemTitle: String { "Dashboard".localized }
    var tabBarImage: UIImage? { Icon.dashboard.getImage() }
    var tabBarTag: Int { 0 }
}

func makeDashboardRootViewDidSelectAction(context: Context) -> TableViewSelectionClosure
{
    { selection in }
//    return { selection in
//        let section = SectionHeader.dashboard[selection.indexPath.section]
//
//        let row = selection.indexPath.row
//
//        var entity: Entity?
//
//        switch section
//        {
//        case .pinned:
//            let pins = getPinnedObjects(context: context)
//            entity = pins[row]
//        case .flows:
//            return
//        case .forecast:
//            let forecasts = getForecastedEvents(context: context)
//            entity = forecasts[row]
//        case .priority:
//            return
//        default:
//            return
//        }
//
//        guard let entity = entity else { return }
//
//        guard let _controller = viewController(
//                for: entity,
//                context: context) else { return }
//
//        self.navigationController?
//            .pushViewController(_controller, animated: true)
}
