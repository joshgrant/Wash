//
//  LibraryController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/28/21.
//

import UIKit

enum LibrarySection: Int, Hashable, Comparable
{
    case main
    
    static func < (lhs: LibrarySection, rhs: LibrarySection) -> Bool
    {
        lhs.rawValue < rhs.rawValue
    }
}

enum LibraryItem: Hashable
{
    case header(HeaderItem)
    case item(LeftImageItem)
}

class LibraryRouter
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
    
    func routeToDetail(entityType: Entity.Type)
    {
        let builder = EntityListBuilder(
            entityType: entityType,
            context: context,
            stream: stream)
        let controller = builder.makeController()
        delegate?.navigationController?.pushViewController(controller, animated: true)
    }
}

protocol LibraryBuilderFactory: Factory
{
    func makeController() -> LibraryController
    func makeRouter() -> LibraryRouter
}

class LibraryBuilder: ListControllerBuilder<LibrarySection, LibraryItem>, LibraryBuilderFactory
{
    // MARK: - Variables
    
    var context: Context
    var stream: Stream
    
    var headerRegistration = HeaderItem.registration
    var itemRegistration = LeftImageItem.registration
    
    // MARK: - Initialization
    
    init(context: Context, stream: Stream)
    {
        self.context = context
        self.stream = stream
    }
    
    // MARK: - Functions
    
    override func makeCollectionViewLayout() -> UICollectionViewLayout
    {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .firstItemInSection
        configuration.footerMode = .none
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    func makeController() -> LibraryController
    {
        .init(builder: self)
    }
    
    func makeRouter() -> LibraryRouter
    {
        .init(context: context, stream: stream)
    }
    
    override func makeInitialModel() -> ListControllerBuilder<LibrarySection, LibraryItem>.ListModel
    {
        [
            .main: makeMainSection()
        ]
    }
    
    private func makeMainSection() -> [LibraryItem]
    {
        var items: [LibraryItem] = []
        
        items = EntityType.libraryVisible.map { entityType in
            return .item(.init(entityType: entityType, context: context))
        }
        
        let header = LibraryItem.header(.init(text: ""))
        items.insert(header, at: 0)
        
        return items
    }
    
    override func makeCellProvider() -> ListControllerBuilder<LibrarySection, LibraryItem>.CellProvider
    {
        { collectionView, indexPath, item in
            switch item
            {
            case .header(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.headerRegistration,
                    for: indexPath,
                    item: item)
            case .item(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.itemRegistration,
                    for: indexPath,
                    item: item)
            }
        }
    }
}

extension LibraryBuilder: ViewControllerTabBarDelegate
{
    var tabBarItemTitle: String { "Library".localized }
    var tabBarImage: UIImage? { Icon.library.image }
    var tabBarTag: Int { 1 }
    
    func makeTabBarItem() -> UITabBarItem
    {
        UITabBarItem(
            title: tabBarItemTitle,
            image: tabBarImage,
            tag: tabBarTag)
    }
}

class LibraryController: ListController<LibrarySection, LibraryItem, LibraryBuilder>
{
    // MARK: - Variables
    
    var router: LibraryRouter
    
    // MARK: - Initialization
    
    override init(builder: LibraryBuilder)
    {
        self.router = builder.makeRouter()
        
        super.init(builder: builder)
        router.delegate = self
        
        title = builder.tabBarItemTitle
        tabBarItem = builder.makeTabBarItem()
    }
    
    // MARK: - View lifecycle
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        reload(animated: animated)
    }
    
    // MARK: - Collection view
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // Route to the detial controller
        let item = model[.main]?[indexPath.row]
        
        switch item
        {
        case .item(let item):
            let entityType = item.entityType
            router.routeToDetail(entityType: entityType.managedObjectType)
        default:
            return
        }
        
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

extension LibraryController: RouterDelegate { }

