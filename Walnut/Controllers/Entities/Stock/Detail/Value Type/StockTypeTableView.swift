//
//  StockTypeTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

struct CheckItem: Equatable
{
    var name: String
    var checked: Bool
}

protocol StockTypeTableViewFactory: Factory
{
    func makeModel() -> TableViewModel
    func makeValueTypeSection() -> TableViewSection
    func makeTransitionTypeSection() -> TableViewSection
}

class StockTypeTableViewContainer: TableViewDependencyContainer
{
    // MARK: - Variables
    
    var stream: Stream
    var style: UITableView.Style
    var stock: Stock
    
    lazy var model = makeModel()
    
    // MARK: - Initialization
    
    init(stream: Stream, style: UITableView.Style, stock: Stock)
    {
        self.stream = stream
        self.style = style
        self.stock = stock
    }
}

extension StockTypeTableViewContainer: StockTypeTableViewFactory
{
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeValueTypeSection(),
            makeTransitionTypeSection()
        ])
    }
    
    // MARK: Value Type
    
    func makeValueTypeSection() -> TableViewSection
    {
        TableViewSection(
            header: .valueType,
            models: makeValueTypeModels())
    }
    
    func makeValueTypeModels() -> [TableViewCellModel]
    {
        ValueType.allCases.map { type in
            CheckmarkCellModel(
                selectionIdentifier: .valueType(type: type),
                title: type.description,
                checked: stock.valueType == type)
        }
    }
    
    // MARK: Transition Type
    
    func makeTransitionTypeSection() -> TableViewSection
    {
        TableViewSection(
            header: .transitionType,
            models: makeTransitionTypeModels())
    }
    
    func makeTransitionTypeModels() -> [TableViewCellModel]
    {
        [
            CheckmarkCellModel(
                selectionIdentifier: .transitionType(type: .continuous),
                title: TransitionType.continuous.title,
                checked: !stock.stateMachine),
            CheckmarkCellModel(
                selectionIdentifier: .transitionType(type: .stateMachine),
                title: TransitionType.stateMachine.title,
                checked: stock.stateMachine)
        ]
    }
}

//class StockTypeListViewContainer: DependencyContainer
//{
//    enum Section: Hashable
//    {
//        case valueType
//        case transitionType
//    }
//
//    enum Item: Hashable
//    {
//        // Value Type
//        case boolean
//        case number(floatingPoints: Int)
//        case percent
//
//        // Transition Type
//        case continuous
//        case stateMachine
//    }
//
//    var dataSource: UICollectionViewDiffableDataSource<Section, Item>
//
//    init()
//    {
//        dataSource = .init()
//    }
//}

//class StockTypeListContainer: DependencyContainer
//{
//    var model: TableViewModel
//}

//class CollectionViewModel
//{
//    var
//}
//
//struct NewCheckmarkSectionModel: Hashable
//{
//    var id: UUID
//    var title: String?
//}
//
//struct NewCheckmarkCellModel: Hashable
//{
//    var title: String
//    var checked: Bool
//}
//
//class NewCheckmarkCell: UICollectionViewListCell
//{
//}
//
//class StockTypeListViewFactory
//{
//    // MARK: - Defined types
//
//    typealias CheckmarkCellRegistration = UICollectionView.CellRegistration<NewCheckmarkCell, NewCheckmarkCellModel>
//    typealias DataSource = UICollectionViewDiffableDataSource<NewCheckmarkSectionModel, NewCheckmarkCellModel>
//    typealias CellProvider = DataSource.CellProvider
//
//    // MARK: - Variables
//
//    lazy var collectionView = UICollectionView()
//    lazy var cellProvider = makeCellProvider()
//    lazy var checkmarkCellRegistration = makeCheckmarkCellRegistration()
//
//    // MARK: - Functions
//
//    func makeCheckmarkCellRegistration() -> CheckmarkCellRegistration
//    {
//        CheckmarkCellRegistration { cell, indexPath, item in
//            var configuration = cell.defaultContentConfiguration()
//            configuration.text = item.title
//
//            cell.contentConfiguration = configuration
//            cell.accessories = item.checked ? [.checkmark()] : []
//            return cell
//        }
//    }
//
//    func makeCellProvider() -> CellProvider
//    {
//        { [unowned self] collectionView, indexPath, item in
//            let model = model.models[indexPath.section][indexPath.item]
//            return collectionView.dequeueConfiguredReusableCell(
//                using: self.checkmarkCellRegistration,
//                for: indexPath,
//                item: item)
//        }
//    }
//
//    func makeDataSource() -> DataSource
//    {
//        UICollectionViewDiffableDataSource(
//            collectionView: collectionView,
//            cellProvider: cellProvider)
//    }
//}
//
//class StockTypeListView: UICollectionView
//{
//    typealias DataSource = UICollectionViewDiffableDataSource<Section, NewCheckmarkCellModel>
//
//    enum Section: Hashable
//    {
//        case valueType
//        case transitionType
//    }
////
////    enum Item: Hashable
////    {
////        // Value Type
////        case boolean
////        case number(floatingPoints: Int)
////        case percent
////
////        // Transition Type
////        case continuous
////        case stateMachine
////    }
//
//    init(model: TableViewModel)
//    {
//        let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
//        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
//        self.collectionViewLayout = layout
//
//        self.dataSource = UICollectionViewDiffableDataSource(collectionView: self, cellProvider: cellProvider)
//    }
//
//    required init?(coder: NSCoder)
//    {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//extension StockTypeListView: UICollectionViewDelegate
//{
//}

class StockTypeTableView: TableView<StockTypeTableViewContainer>
{
    // MARK: - Variables
    
//    var stock: Stock
    
    // TODO: Model?
//    var valueItems: [CheckItem]
//    var stateMachineItems: [CheckItem]
    
    // MARK: - Initialization
    
//    init(stock: Stock)
//    {
//        self.stock = stock
//        self.valueItems = Self.makeValueTypeItems(stock: stock)
//        self.stateMachineItems = Self.makeStateMachineItems(stock: stock)
//        super.init()
//    }
    
//    required init(container: StockTypeTableViewContainer)
//    {
//        super.init(container: container)
//    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Set the values on the stock
        // Reload the table view?
        
        tableView.deselectRow(at: indexPath, animated: true)

        /*
        let newItems = Self.makeValueTypeItems(stock: container.stock)
        tableView.animateRowChanges(oldData: valueItems, newData: newItems)
        valueItems = newItems
         */
        
//        let oldAmountPath = path(for: stock.valueType)
//        let oldTransitionPath = path(for: stock.stateMachine)
//
//        switch (indexPath.section, indexPath.row)
//        {
//        case (0, 0):
//            stock.valueType = .boolean
//        case (0, 1):
//            stock.valueType = .integer
//        case (0, 2):
//            stock.valueType = .decimal
//        case (0, 3):
//            stock.valueType = .percent
//        case (1, 0):
//            stock.stateMachine = false
//        case (1, 1):
//            stock.stateMachine = true
//        default:
//            break
//        }
//
//        let newAmountPath = path(for: stock.valueType)
//        let newTransitionPath = path(for: stock.stateMachine)
//
//        model = makeModel()
//
//        var pathsToReload: [IndexPath] = []
//
//        if oldAmountPath.row != newAmountPath.row
//        {
//            pathsToReload.append(contentsOf: [oldAmountPath, newAmountPath])
//        }
//
//        if oldTransitionPath.row != newTransitionPath.row
//        {
//            pathsToReload.append(contentsOf: [oldTransitionPath, newTransitionPath])
//        }
//
//        tableView.reloadRows(at: pathsToReload, with: .automatic)
        
        // FIXME: Not sure if this should be before or after updating the cell models
//        let model = model.models[indexPath.section][indexPath.row]
//        let message = TableViewSelectionMessage(tableView: tableView, cellModel: model)
//        
//        AppDelegate.shared.mainStream.send(message: message)
    }
    
    static func makeValueTypeItems(stock: Stock) -> [CheckItem]
    {
        [
            CheckItem(name: "Boolean".localized, checked: stock.valueType == .boolean),
            CheckItem(name: "Integer".localized, checked: stock.valueType == .integer),
            CheckItem(name: "Decimal".localized, checked: stock.valueType == .decimal),
            CheckItem(name: "Percent".localized, checked: stock.valueType == .percent)
        ]
    }
    
    static func makeStateMachineItems(stock: Stock) -> [CheckItem]
    {
        [
            CheckItem(name: "Continuous".localized, checked: !stock.stateMachine),
            CheckItem(name: "State Machine".localized, checked: stock.stateMachine)
        ]
    }
    
    func path(for amountType: ValueType) -> IndexPath
    {
        return IndexPath(row: Int(amountType.rawValue), section: 0)
    }
    
    func path(for stateMachine: Bool) -> IndexPath
    {
        switch stateMachine
        {
        case true:
            return IndexPath(row: 1, section: 1)
        case false:
            return IndexPath(row: 0, section: 1)
        }
    }
    
    // MARK: - Model
    
    
}
