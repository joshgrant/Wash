//
//  EntityListController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/28/21.
//

import UIKit

enum EntityListSection: Hashable
{
    case main
}

enum EntityListItem: Hashable
{
    case header(HeaderItem)
    case item(DetailItem)
}

protocol EntityListFactory: Factory
{
    func makeController() -> EntityListController
    func makeRouter() -> EntityListRouter
    func makeAddButtonItem(target: EntityListResponder) -> UIBarButtonItem
    func makeSearchController(delegate: UISearchControllerDelegate) -> UISearchController
}

@objc protocol EntityListResponder
{
    func addButtonItemDidTouchUpInside(_ sender: UIBarButtonItem)
}

class EntityListRouter
{
    // MARK: - Variables
    
    var context: Context
    var stream: Stream
    
    weak var delegate: RouterDelegate?
    
    // MARK: - Initialization
    
    init(context: Context, stream: Stream)
    {
        self.context = context
        self.stream = stream
    }
    
    // MARK: - Functions
    
    func routeToDetail(entity: Entity)
    {
        let detail = entity.detailController(
            context: context,
            stream: stream)
        delegate?.navigationController?.pushViewController(detail, animated: true)
    }
    
    func routeToAdd(entityType: Entity.Type)
    {
        switch entityType
        {
        case is System.Type:
            routeToAddSystem()
        case is Stock.Type:
            routeToAddStock()
        case is Flow.Type:
            routeToAddFlow()
        case is Task.Type:
            routeToAddTask()
        case is Event.Type:
            routeToAddEvent()
        case is Conversion.Type:
            routeToAddConversion()
        case is Condition.Type:
            routeToAddCondition()
        case is Symbol.Type:
            routeToAddSymbol()
        case is Note.Type:
            routeToAddNote()
        case is Unit.Type:
            routeToAddUnit()
        default:
            fatalError()
        }
    }
    
    private func routeToAddSystem()
    {
        let builder = NewSystemControllerBuilder(context: context, stream: stream)
        let controller = builder.makeController()
        let navigation = UINavigationController(rootViewController: controller)
        navigation.isModalInPresentation = true
        delegate?.navigationController?.present(navigation, animated: true, completion: nil)
        //    default:
        //        let entity = entityType.init(context: container.context)
        //        entity.createdDate = Date()
        //        let detail = entity.detailController(context: container.context, stream: container.stream)
        //        delegate?.navigationController?.pushViewController(detail, animated: true)
        //        container.context.quickSave()
    }
    
    private func routeToAddStock()
    {
        let container = NewStockControllerContainer(context: context, stream: stream)
        let controller = container.makeController()
        let detailNavigation = UINavigationController(rootViewController: controller)
        detailNavigation.isModalInPresentation = true
        delegate?.navigationController?.present(detailNavigation, animated: true, completion: nil)
    }
    
    private func routeToAddFlow()
    {
        fatalError()
    }
    
    private func routeToAddTask()
    {
        fatalError()
    }
    
    private func routeToAddEvent()
    {
        fatalError()
    }
    
    private func routeToAddConversion()
    {
        fatalError()
    }
    
    private func routeToAddCondition()
    {
        fatalError()
    }
    
    private func routeToAddSymbol()
    {
        fatalError()
    }
    
    private func routeToAddNote()
    {
        fatalError()
    }
    
    private func routeToAddUnit()
    {
        fatalError()
    }
}

protocol EntityListSwipeActionsDelegate: AnyObject
{
    func handleDelete(action: UIContextualAction, indexPath: IndexPath)
    func handlePin(action: UIContextualAction, indexPath: IndexPath)
}

class EntityListBuilder: ListControllerBuilder<EntityListSection, EntityListItem>, EntityListFactory
{
    // MARK: - Variables
    
    var entityType: Entity.Type
    
    var context: Context
    var stream: Stream
    
    weak var swipeActionsDelegate: EntityListSwipeActionsDelegate?
    
    // MARK: - Initialization
    
    init(entityType: Entity.Type, context: Context, stream: Stream)
    {
        self.entityType = entityType
        self.context = context
        self.stream = stream
    }
    
    // MARK: - Functions
    
    func makeController() -> EntityListController
    {
        .init(builder: self)
    }
    
    func makeRouter() -> EntityListRouter
    {
        .init(context: context, stream: stream)
    }
    
    func makeAddButtonItem(target: EntityListResponder) -> UIBarButtonItem
    {
        UIBarButtonItem(
            barButtonSystemItem: .add,
            target: target,
            action: #selector(target.addButtonItemDidTouchUpInside(_:)))
    }
    
    func makeSearchController(delegate: UISearchControllerDelegate) -> UISearchController
    {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = delegate
        return searchController
    }
    
    override func makeCollectionViewLayout() -> UICollectionViewLayout
    {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .firstItemInSection
        configuration.footerMode = .supplementary
        
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            UISwipeActionsConfiguration(actions: [
                .init(style: .destructive, title: "Delete".localized, handler: { [weak self] action, view, closure in
                    self?.swipeActionsDelegate?.handleDelete(action: action, indexPath: indexPath)
                    closure(true) // true if delete was successful
                }),
                .init(style: .normal, title: "Pin".localized, handler: { [weak self] action, view, closure in
                    self?.swipeActionsDelegate?.handlePin(action: action, indexPath: indexPath)
                    closure(true) // true if delete was successful
                })
            ])
        }
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    override func makeInitialModel() -> ListControllerBuilder<EntityListSection, EntityListItem>.ListModel
    {
        [
            .main: makeMainSection()
        ]
    }
    
    private func makeMainSection() -> [EntityListItem]
    {
        var items: [EntityListItem] = []
        
        items = entityType
            .all(context: context)
            .compactMap { entity in
                guard let entity = entity as? Named else { fatalError() }
                return .item(.init(text: entity.title))
            }
        
        let header = EntityListItem.header(.init(text: ""))
        items.insert(header, at: 0)
        
        return items
    }
    
    override func makeCellProvider() -> ListControllerBuilder<EntityListSection, EntityListItem>.CellProvider
    {
        { collectionView, indexPath, item in
            switch item
            {
            case .header(let item):
                return collectionView.dequeueConfiguredReusableCell(using: item.registration, for: indexPath, item: item)
            case .item(let item):
                return collectionView.dequeueConfiguredReusableCell(using: item.registration, for: indexPath, item: item)
            }
        }
    }
}

class EntityListController: ListController<EntityListSection, EntityListItem, EntityListBuilder>
{
    // MARK: - Variables
    
    lazy var addButtonItem: UIBarButtonItem = builder.makeAddButtonItem(target: self)
    lazy var searchController: UISearchController = builder.makeSearchController(delegate: self)
    
    // MARK: - Initialization
    
    override init(builder: EntityListBuilder)
    {
        super.init(builder: builder)
        title = builder.entityType.readableName.pluralize()
        
        builder.swipeActionsDelegate = self
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = addButtonItem
        navigationItem.searchController = searchController
    }
    
    // MARK: - Collection view
    
    
    
    // TODO: Handle pin action
    // Handle delete action:
    /*
     container.context.perform { [unowned self] in
     let object = message.entity
     self.container.context.delete(object)
     self.container.context.quickSave()
     
     DispatchQueue.main.async
     {
     self.container.tableView.reload(shouldReloadTableView: false)
     self.container.tableView.beginUpdates()
     self.container.tableView.deleteRows(at: [message.indexPath], with: .automatic)
     self.container.tableView.endUpdates()
     }
     }
     */
}

extension EntityListController: EntityListResponder
{
    @objc func addButtonItemDidTouchUpInside(_ sender: UIBarButtonItem)
    {
        
    }
}

extension EntityListController: UISearchControllerDelegate
{
    
}

extension EntityListController: EntityListSwipeActionsDelegate
{
    func handleDelete(action: UIContextualAction, indexPath: IndexPath)
    {
        builder.context.perform { [unowned self] in
            // Subtract one to account for the invisible header
            let entity = self.builder.entityType.all(context: builder.context)[indexPath.row - 1]
            builder.context.delete(entity)
            builder.context.quickSave()
            
            DispatchQueue.main.async
            {
                self.model = builder.makeInitialModel()
                self.applyModel(animated: true)
            }
        }
    }
    
    func handlePin(action: UIContextualAction, indexPath: IndexPath)
    {
        // Subtract one to account for the invisible header
        let entity = self.builder.entityType.all(context: builder.context)[indexPath.row - 1]
        if let pinnable = entity as? Pinnable
        {
            pinnable.isPinned.toggle()
            builder.context.quickSave()
        }
    }
}
