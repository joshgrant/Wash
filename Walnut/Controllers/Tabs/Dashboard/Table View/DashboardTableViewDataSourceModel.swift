//
//  DashboardTableViewDataSourceModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import CoreData
import ProgrammaticUI

class DashboardTableViewDataSourceModel: TableViewDataSourceModel
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
            makePinnedModels(context: context),
            makeSuggestedFlowsModels(context: context),
            makeForecastModels(context: context),
            [
            ],
        ]
    }
    
    // MARK: - Utility
    
    static func getForecastedEvents(context: Context) -> [Event]
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
    
    static func makeForecastModels(context: Context) -> [TableViewCellModel]
    {
        let events = getForecastedEvents(context: context)
        return events.map
        {
            let title = $0.title
            let detail = "Mon, Apr 3"
            return DetailCellModel(title: title, detail: detail)
        }
    }
    
    static func makePinnedModels(context: Context) -> [TableViewCellModel]
    {
        let pins = getPinnedObjects(context: context)
        return pins.map
        {
            TextCellModel(title: $0.title, disclosureIndicator: true)
        }
    }
    
    static func getPinnedObjects(context: Context) -> [Pinnable]
    {
        let request = Entity.makePinnedObjectsFetchRequest()
        do
        {
            return try context.fetch(request).compactMap { $0 as? Pinnable }
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    static func makeDashboardSuggestedFlowsPredicate() -> NSPredicate
    {
        NSPredicate(format: "suggestedIn.@count > %i", 0)
    }
    
    static func makeDashboardSuggestedFlowsFetchRequest() -> NSFetchRequest<Flow>
    {
        let fetchRequest: NSFetchRequest<Flow> = Flow.fetchRequest()
        fetchRequest.predicate = makeDashboardSuggestedFlowsPredicate()
        fetchRequest.shouldRefreshRefetchedObjects = true
        return fetchRequest
    }
    
    static func getSuggestedFlows(context: Context) -> [Flow]
    {
        let request = makeDashboardSuggestedFlowsFetchRequest()
        do
        {
            return try context.fetch(request)
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    static func makeSuggestedFlowsModels(context: Context) -> [TableViewCellModel]
    {
        let flows = getSuggestedFlows(context: context)
        return flows.map
        {
            TextCellModel(title: $0.title, disclosureIndicator: true)
        }
    }
}


/*
 events.map {
 let title = $0.unwrappedName ?? ""
 return EventListCellModel(title: title, detail: "Mon, Apr 3")
 }
 */
