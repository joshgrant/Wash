//
//  DashboardTableViewDataSourceModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import CoreData
import UIKit

class DashboardTableViewDataSourceModel: TableViewDataSourceModel
{
    // MARK: - Variables
    
    weak var context: Context?
    
    // MARK: - Initialization
    
    convenience init(context: Context)
    {
        let cellModels = Self.makeCellModels(context: context)
        self.init(cellModels: cellModels)
        self.context = context
    }
    
    override func reload()
    {
        guard let context = context else {
            assertionFailure("The context was nil")
            return
        }
        
        self.cellModels = Self.makeCellModels(context: context)
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
            return DetailCellModel(
                title: title,
                detail: detail,
                disclosure: true)
        }
    }
    
    static func makePinnedModels(context: Context) -> [TableViewCellModel]
    {
        let pins = getPinnedObjects(context: context)
        return pins.compactMap
        {
            guard let type = EntityType.type(from: $0) else { return nil }

            return RightImageCellModel(
                title: $0.title,
                detail: type.icon,
                disclosure: true)
        }
    }
    
    static func getPinnedObjects(context: Context) -> [Pinnable]
    {
        let request = Entity.makePinnedObjectsFetchRequest(context: context)
        do
        {
            let result = try context.fetch(request)
            print(result)
            
            return result.compactMap { $0 as? Pinnable }
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
