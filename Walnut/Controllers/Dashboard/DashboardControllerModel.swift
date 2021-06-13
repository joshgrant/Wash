//
//  DashboardControllerModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit
import CoreData

class DashboardControllerModel: ControllerModel
{
    // MARK: - Variables
    
    var tableViewModel: DashboardTableViewModel
    var backgroundColor: UIColor { #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) }
    
    // MARK: - Initialization
    
    required init(tableViewModel: DashboardTableViewModel)
    {
        self.tableViewModel = tableViewModel
        super.init()
    }
    
    convenience override init()
    {
        let model = DashboardTableViewModel()
        self.init(tableViewModel: model)
    }
}

// MARK: - Tab Bar

extension DashboardControllerModel: ControllerModelTabBarDelegate
{
    var tabBarItemTitle: String { "Dashboard".localized }
    var tabBarImage: UIImage? { Icon.dashboard.getImage() }
    var tabBarTag: Int { 0 }
}

func getForecastedEvents(context: Context) -> [Event]
{
    let fetchRequest = makeDateSourcesFetchRequest()
    do {
        let sources = try context.fetch(fetchRequest)
        let events = Event.eventsFromSources(sources)
        return events
    } catch {
        assertionFailure(error.localizedDescription)
        return []
    }
}

func makeForecastModels(context: Context) -> [TableViewCellModel]
{
//    let events = getForecastedEvents(context: context)
//    return EventListCellModel.eventCellModelsFrom(events: events)
    return []
}

func makePinnedModels(context: Context) -> [TableViewCellModel]
{
//    let pins = getPinnedObjects(context: context)
//    let cells = PinnedCellModel.pinnedCellModels(from: pins)
//    return cells
    return []
}

func getPinnedObjects(context: Context) -> [Entity]
{
    let request = Entity.makePinnedObjectsFetchRequest()
    do {
        let results = try context.fetch(request)
        return results
    } catch {
        assertionFailure(error.localizedDescription)
        return []
    }
}

func makeDashboardSuggestedFlowsPredicate() -> NSPredicate
{
    NSPredicate(format: "@suggestedIn.count > %@", 0)
}

func makeDashboardSuggestedFlowsFetchRequest() -> NSFetchRequest<Flow>
{
    let fetchRequest: NSFetchRequest<Flow> = Flow.fetchRequest()
    fetchRequest.predicate = makeDashboardSuggestedFlowsPredicate()
    fetchRequest.shouldRefreshRefetchedObjects = true
    return fetchRequest
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
