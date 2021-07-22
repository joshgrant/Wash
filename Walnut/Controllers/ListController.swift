//
//  ListController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/22/21.
//

import UIKit

typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
typealias CellProvider = DataSource.CellProvider
typealias SupplementaryProvider = DataSource.SupplementaryViewProvider
typealias FooterRegistration = UICollectionView.SupplementaryRegistration<UICollectionReusableView>
typealias ListModel = [Section: [Item]]

protocol ListControllerFactory: Factory
{
    func makeResponder() -> ListControllerResponder
    
    func makeInitialModel(delegate: SuggestedItemDelegate) -> ListModel
    func makeCollectionViewLayout() -> UICollectionViewLayout
    func makeCollectionView() -> UICollectionView
    func makeFooterRegistration() -> FooterRegistration
    func makeCellProvider() -> CellProvider
    func makeSupplementaryProvider(registration: FooterRegistration) -> SupplementaryProvider
    func makeDataSource(collectionView: UICollectionView) -> DataSource
}

protocol ListControllerContainer: Container
{
}

class ListControllerBuilder: ListControllerFactory & ListControllerContainer
{
    // MARK: - Functions
    
    func makeResponder() -> ListControllerResponder
    {
        .init()
    }
    
    func makeInitialModel(delegate: SuggestedItemDelegate) -> ListModel
    {
        [
            .pinned: [
                .header(.init(text: "Pinned",
                              image: .init(systemName: "pin.fill"))),
                .pinned(.init(text: "Hunger",
                              image: UIImage(systemName: "shippingbox")!)),
                .pinned(.init(text: "Nutrition",
                              image: UIImage(systemName: "network")!)),
                .pinned(.init(text: "Sink",
                              image: UIImage(systemName: "hourglass.tophalf.fill")!)),
            ],
            .suggested: [
                .header(.init(text: "Suggested Flows",
                              image: .init(systemName: "wind"))),
                .suggested(.init(text: "Wash dishes",
                                 secondaryText: "Chores",
                                 checked: false,
                                 delegate: delegate)),
                .suggested(.init(text: "Eat dinner",
                                 secondaryText: "Nutrition",
                                 checked: true,
                                 delegate: delegate))
            ],
            .forecast: [
                .header(.init(text: "Forecast",
                              image: .init(systemName: "calendar"))),
                .forecast(.init(text: "Charlie Horse 5k",
                                secondaryText: "Mon, Apr 3"))
            ],
            .priority: [
                .header(.init(text: "Priority",
                              image: .init(systemName: "network"))),
                .priority(.init(text: "Chores",
                                secondaryText: "25%"))
            ]
        ]
    }
    
    func makeCollectionViewLayout() -> UICollectionViewLayout
    {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .firstItemInSection
        configuration.footerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    func makeCollectionView() -> UICollectionView
    {
        let layout = makeCollectionViewLayout()
        return .init(frame: .zero, collectionViewLayout: layout)
    }
    
    func makeFooterRegistration() -> FooterRegistration
    {
        .init(elementKind: UICollectionView.elementKindSectionFooter) { view, kind, indexPath in
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }
    
    func makeCellProvider() -> CellProvider
    {
        { collectionView, indexPath, item in
            switch item
            {
            case .header(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            case .pinned(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            case .suggested(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            case .forecast(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            case .priority(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: item.registration,
                    for: indexPath,
                    item: item)
            }
        }
    }
    
    func makeSupplementaryProvider(registration: FooterRegistration) -> SupplementaryProvider
    {
        { collectionView, kind, indexPath in
            
            switch kind
            {
            case UICollectionView.elementKindSectionHeader:
                return nil
            case UICollectionView.elementKindSectionFooter:
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: registration,
                    for: indexPath)
            default:
                fatalError()
            }
        }
    }
    
    func makeDataSource(collectionView: UICollectionView) -> DataSource
    {
        let cellProvider = makeCellProvider()
        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        let footerRegistration = makeFooterRegistration()
        dataSource.supplementaryViewProvider = makeSupplementaryProvider(registration: footerRegistration)
        return dataSource
    }
}

protocol Responder { }

class ListControllerResponder: Responder
{
    
}

class ListController<Builder: ListControllerFactory & ListControllerContainer>: UIViewController, UICollectionViewDelegate, SuggestedItemDelegate
{
    // MARK: - Variables
    
    var builder: Builder
    var responder: ListControllerResponder
    var collectionView: UICollectionView
    var dataSource: DataSource
    lazy var model: ListModel = builder.makeInitialModel(delegate: self)
    
    // MARK: - Initialization
    
    init(builder: Builder)
    {
        self.builder = builder
        
        let responder = builder.makeResponder()
        let collectionView = builder.makeCollectionView()
        
        self.responder = responder
        self.collectionView = collectionView
        
        self.dataSource = builder.makeDataSource(collectionView: collectionView)
        
        super.init(nibName: nil, bundle: nil)
        applyModel(animated: false)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - View lifecycle
    
    override func loadView()
    {
        view = collectionView
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(
            self,
            action: #selector(handleRefreshControl),
            for: .valueChanged)
    }
    
    // MARK: - Functions
    
    func applyModel(animated: Bool)
    {
        for (section, items) in model
        {
            guard let first = items.first else { continue }
            let rest = Array(items.suffix(from: 1)) // Is this efficient?
            
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
            sectionSnapshot.append([first])
            sectionSnapshot.append(rest, to: first)
            sectionSnapshot.expand([first])
            
            dataSource.apply(
                sectionSnapshot,
                to: section,
                animatingDifferences: animated)
        }
    }
    
    @objc func handleRefreshControl()
    {
        model = model.compactMapValues({ items in
            return items.compactMap { item in
                switch item
                {
                case .suggested(let item):
                    return item.checked ? nil : .suggested(item)
                default:
                    return item
                }
            }
        })
        
        applyModel(animated: true)
        collectionView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: - Suggested Item Delegate
    
    func suggestedItemUpdated(to checked: Bool, item: SuggestedItem)
    {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([.suggested(item)])
        dataSource.apply(snapshot)
    }
}
