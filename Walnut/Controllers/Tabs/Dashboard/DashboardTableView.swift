//
//  DashboardTableViewDataSourceModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import CoreData
import UIKit

protocol DashboardTableViewFactory: Factory
{
    func makeTableView() -> DashboardTableView
    func makeModel() -> TableViewModel
    func makePinnedSection() -> TableViewSection
    func makeFlowsSection() -> TableViewSection
    func makeForecastSection() -> TableViewSection
    func makePrioritySection() -> TableViewSection
    func makeDashboardSuggestedFlowsPredicate() -> NSPredicate
    func makeDashboardSuggestedFlowsFetchRequest() -> NSFetchRequest<Flow>
}

class DashboardTableViewContainer: TableViewDependencyContainer
{
    // MARK: - Variables
    
    var stream: Stream
    var context: Context
    var style: UITableView.Style
    
    lazy var model: TableViewModel = makeModel()
    
    // MARK: - Initialization
    
    init(stream: Stream, context: Context, style: UITableView.Style)
    {
        self.stream = stream
        self.context = context
        self.style = style
    }
}

extension DashboardTableViewContainer: DashboardTableViewFactory
{
    func makeTableView() -> DashboardTableView
    {
        DashboardTableView(container: self)
    }

    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makePinnedSection(),
            makePrioritySection(),
            makeForecastSection(),
            makeFlowsSection(),
        ])
    }
    
    // MARK: Pinned
    
    func makePinnedSection() -> TableViewSection
    {
        TableViewSection(
            header: .pinned,
            models: makePinnedModels())
    }
    
    private func makePinnedModels() -> [TableViewCellModel]
    {
        let request = Entity.makePinnedObjectsFetchRequest(context: context)
        
        do
        {
            let result = try context.fetch(request)
            return result.compactMap { item in
                guard let pin = item as? Pinnable else { return nil }
                guard let type = EntityType.type(from: pin) else { return nil }
                
                return RightImageCellModel(
                    selectionIdentifier: .pinned(entity: pin),
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
    
    func makeFlowsSection() -> TableViewSection
    {
        TableViewSection(
            header: .flows,
            models: makeFlowModels())
    }
    
    private func makeFlowModels() -> [TableViewCellModel]
    {
        let request = makeDashboardSuggestedFlowsFetchRequest()
        do
        {
            let result = try context.fetch(request)
            return result.map { flow in
                TextCellModel(
                    selectionIdentifier: .flow(flow: flow),
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
    
    func makeForecastSection() -> TableViewSection
    {
        TableViewSection(
            header: .forecast,
            models: makeForecastModels())
    }
    
    private func makeForecastModels() -> [TableViewCellModel]
    {
        let request = makeDateSourcesFetchRequest()
        do
        {
            let result = try context.fetch(request)
            let events = Event.eventsFromSources(result)
            return events.map { event in
                DetailCellModel(
                    selectionIdentifier: .event(event: event),
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
    
    func makePrioritySection() -> TableViewSection
    {
        TableViewSection(
            header: .priority,
            models: makePriorityModels())
    }
    
    private func makePriorityModels() -> [TableViewCellModel]
    {
        // TODO: Fetch unideal values
        // TODO: Sort on the ideal value, ascending
        
        let request: NSFetchRequest<System> = System.fetchRequest()
        request.predicate = NSPredicate(value: true)
        request.sortDescriptors = [NSSortDescriptor(key: "ideal", ascending: true)]
        
        do
        {
            let result = try context.fetch(request)
            return result.map { system in
                DetailCellModel(
                    selectionIdentifier: .system(system: system),
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

class DashboardTableView: TableView<DashboardTableViewContainer>
{
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var entity: Entity
        let cellModel = container.model.models[indexPath.section][indexPath.row]
        
        switch cellModel.selectionIdentifier
        {
        case .pinned(let e):
            entity = e
        case .entity(let e):
            entity = e
        case .system(let e):
            entity = e
        case .flow(let e):
            entity = e
        default:
            fatalError("Unhandled selection identifier")
        }
        
        let message = TableViewEntitySelectionMessage(entity: entity, tableView: tableView, cellModel: cellModel)
        container.stream.send(message: message)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
