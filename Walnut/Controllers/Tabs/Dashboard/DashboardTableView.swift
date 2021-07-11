//
//  DashboardTableViewDataSourceModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import CoreData
import UIKit

class DashboardTableView: TableView
{
    // MARK: - Variables
    
    weak var context: Context?
    
    // MARK: - Initialization
    
    init(context: Context)
    {
        self.context = context
        super.init()
    }
    
    // MARK: - Functions
    
    override func makeModel() -> TableViewModel
    {
        guard let context = context else
        {
            fatalError("The context is nil")
        }
        
        return TableViewModel(sections: [
            makePinnedSection(context: context),
            makePrioritySection(context: context),
            makeForecastSection(context: context),
            makeFlowsSection(context: context),
        ])
    }
    
    // MARK: Pinned
    
    func makePinnedSection(context: Context) -> TableViewSection
    {
        TableViewSection(
            header: .pinned,
            models: makePinnedModels(context: context))
    }
    
    func makePinnedModels(context: Context) -> [TableViewCellModel]
    {
        let request = Entity.makePinnedObjectsFetchRequest(context: context)
        
        do
        {
            let result = try context.fetch(request)
            return result.compactMap { item in
                guard let pin = item as? Pinnable else { return nil }
                guard let type = EntityType.type(from: pin) else { return nil }
                
                return RightImageCellModel(
                    title: pin.title,
                    detail: type.icon,
                    disclosure: true)
            }
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    // MARK: Flows
    
    func makeFlowsSection(context: Context) -> TableViewSection
    {
        TableViewSection(
            header: .flows,
            models: makeFlowModels(context: context))
    }
    
    func makeFlowModels(context: Context) -> [TableViewCellModel]
    {
        let request = makeDashboardSuggestedFlowsFetchRequest()
        do
        {
            let result = try context.fetch(request)
            return result.map { flow in
                TextCellModel(
                    title: flow.title,
                    disclosureIndicator: true)
            }
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    // MARK: Forecast
    
    func makeForecastSection(context: Context) -> TableViewSection
    {
        TableViewSection(
            header: .forecast,
            models: makeForecastModels(context: context))
    }
    
    func makeForecastModels(context: Context) -> [TableViewCellModel]
    {
        let request = makeDateSourcesFetchRequest()
        do
        {
            let result = try context.fetch(request)
            let events = Event.eventsFromSources(result)
            return events.map { event in
                DetailCellModel(
                    title: event.title,
                    detail: "FIX ME",
                    disclosure: true)
            }
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    // MARK: Priority
    
    func makePrioritySection(context: Context) -> TableViewSection
    {
        TableViewSection(
            header: .priority,
            models: makePriorityModels(context: context))
    }
        
    func makePriorityModels(context: Context) -> [TableViewCellModel]
    {
        // TODO: Fetch unideal values
        // TODO: Sort on the ideal value, ascending
        
        let request: NSFetchRequest<System> = System.fetchRequest()
        request.predicate = NSPredicate(value: true)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do
        {
            let result = try context.fetch(request)
            return result.map { system in
                DetailCellModel(
                    title: system.title,
                    detail: "FIXME", // TODO: Should be the ideal value
                    disclosure: true)
            }
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }

    // MARK: - Utility
    
    func makeDashboardSuggestedFlowsPredicate() -> NSPredicate
    {
        NSPredicate(format: "suggestedIn.@count > %i", 0)
    }
    
    func makeDashboardSuggestedFlowsFetchRequest() -> NSFetchRequest<Flow>
    {
        let fetchRequest: NSFetchRequest<Flow> = Flow.fetchRequest()
        fetchRequest.predicate = makeDashboardSuggestedFlowsPredicate()
        fetchRequest.shouldRefreshRefetchedObjects = true
        return fetchRequest
    }
}
