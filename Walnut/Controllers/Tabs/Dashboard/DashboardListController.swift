//
//  DashboardListController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import UIKit

// TODO: Parent class that takes a generic factory and dependency container...

//class DashboardListController: UIViewController
//{
//    // MARK: - Variables
//    
//    var id = UUID()
//    
//    var builder: DashboardListControllerBuilder
//    var collectionView: UICollectionView
//    var dataSource: UICollectionViewDiffableDataSource<DashboardSection, DashboardItem>
//    
//    // MARK: - Initialization
//    
//    required init(builder: DashboardListControllerBuilder)
//    {
//        let collectionView = builder.makeCollectionView()
//        
//        self.builder = builder
//        self.collectionView = collectionView
//        self.dataSource = builder.makeDataSource(collectionView: collectionView)
//        super.init(nibName: nil, bundle: nil)
//        subscribe(to: builder.stream)
//        
//        title = builder.tabBarItemTitle
//        tabBarItem = builder.makeTabBarItem()
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder)
//    {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    deinit
//    {
//        unsubscribe(from: builder.stream)
//    }
//    
//    // MARK: - View lifecycle
//    
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        
//        collectionView.delegate = self
//        collectionView.dataSource = dataSource
//        
//        view.embed(collectionView)
//        
//        dataSource.apply(builder.makeInitialSnapshot())
////        dataSource.apply(builder.pinnedSectionSnapshot(), to: .pinned, animatingDifferences: false)
////        dataSource.apply(builder.flowSectionSnapshot(), to: .suggested, animatingDifferences: false)
//    }
//}
//
//extension DashboardListController: UICollectionViewDelegate
//{
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    {
//        // TODO: Send a message
//        collectionView.deselectItem(at: indexPath, animated: true)
//        
//        /*
//         var entity: Entity
//         let cellModel = container.model.models[indexPath.section][indexPath.row]
//         
//         switch cellModel.selectionIdentifier
//         {
//         case .pinned(let e):
//         entity = e
//         case .entity(let e):
//         entity = e
//         case .system(let e):
//         entity = e
//         case .flow(let e):
//         entity = e
//         default:
//         fatalError("Unhandled selection identifier")
//         }
//         
//         let message = TableViewEntitySelectionMessage(entity: entity, tableView: tableView, cellModel: cellModel)
//         container.stream.send(message: message)
//         
//         tableView.deselectRow(at: indexPath, animated: true)
//         */
//    }
//}
//
//
//extension DashboardListController: Subscriber
//{
//    func receive(message: Message)
//    {
//        // TODO:
//        // When a pin message is received, reload
//        // When a delete message is received, reload
//        // When an entity is edited, reload
//        // When an entity is selected (from this view) reload
//    }
//}
/*
 
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

 */
