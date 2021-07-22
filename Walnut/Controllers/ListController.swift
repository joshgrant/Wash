//
//  ListController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/22/21.
//

import UIKit

protocol ListControllerFactory: Factory
{
    associatedtype Section: Hashable
    associatedtype Item: Hashable
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias CellProvider = UICollectionViewDiffableDataSource<Section, Item>.CellProvider
    typealias SupplementaryProvider = UICollectionViewDiffableDataSource<Section, Item>.SupplementaryViewProvider
    typealias FooterRegistration = UICollectionView.SupplementaryRegistration<UICollectionReusableView>
    typealias ListModel = [Section: [Item]]
    
    func makeResponder() -> ListControllerResponder
    
    func makeInitialModel() -> ListModel
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

class ListControllerBuilder<S: Hashable, I: Hashable>: ListControllerFactory & ListControllerContainer
{
    // MARK: - Defined types
    
    typealias Section = S
    typealias Item = I
    
    // MARK: - Variables
    
    //    weak var delegate: SuggestedItemDelegate?
    
    // MARK: - Functions
    
    func makeResponder() -> ListControllerResponder
    {
        .init()
    }
    
    func makeInitialModel() -> ListModel
    {
        fatalError("Implement in subclass")
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
        fatalError("Implement in subclass")
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

class ListController<S: Hashable, I: Hashable, Builder: ListControllerBuilder<S, I>>: UIViewController, UICollectionViewDelegate
{
    // MARK: - Variables
    
    var builder: Builder
    var responder: ListControllerResponder
    var collectionView: UICollectionView
    var dataSource: Builder.DataSource
    lazy var model: Builder.ListModel = builder.makeInitialModel()
    
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
        
        applyModel(animated: false)
    }
    
    // MARK: - Functions
    
    func applyModel(animated: Bool)
    {
        for (section, items) in model
        {
            guard let first = items.first else { continue }
            let rest = Array(items.suffix(from: 1)) // Is this efficient?
            
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Builder.Item>()
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
        collectionView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

class DashboardListBuilder: ListControllerBuilder<DashboardSection, DashboardItem>
{
    // MARK: - Variables
    
    weak var delegate: SuggestedItemDelegate?
    
    // MARK: - Functions
    
    override func makeCellProvider() -> CellProvider
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
    
    override func makeInitialModel() -> ListModel
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
}

class DashboardListController: ListController<DashboardSection, DashboardItem, DashboardListBuilder>
{
    // MARK: - Variables
    
    var id = UUID()
    
    // MARK: - Initialization
    
    override init(builder: DashboardListBuilder)
    {
        super.init(builder: builder)
        self.builder.delegate = self
    }
    
    // MARK: - Functions
    
    @objc override func handleRefreshControl()
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
        super.handleRefreshControl()
    }
}

extension DashboardListController: SuggestedItemDelegate
{
    func suggestedItemUpdated(to checked: Bool, item: SuggestedItem)
    {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([.suggested(item)])
        dataSource.apply(snapshot)
    }
}

extension DashboardListController: Subscriber
{
    func receive(message: Message)
    {
        print("Message: \(message)")
    }
}
