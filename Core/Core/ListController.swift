//
//  ListController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/22/21.
//

import UIKit

public protocol ListControllerFactory: Factory
{
    associatedtype Section: Comparable & Hashable
    associatedtype Item: Hashable
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias CellProvider = UICollectionViewDiffableDataSource<Section, Item>.CellProvider
    typealias SupplementaryProvider = UICollectionViewDiffableDataSource<Section, Item>.SupplementaryViewProvider
    typealias FooterRegistration = UICollectionView.SupplementaryRegistration<UICollectionReusableView>
    typealias ListModel = [Section: [Item]]
    
    func makeInitialModel() -> ListModel
    func makeCollectionViewLayout() -> UICollectionViewLayout
    func makeCollectionView() -> UICollectionView
    func makeFooterRegistration() -> FooterRegistration
    func makeCellProvider() -> CellProvider
    func makeSupplementaryProvider(registration: FooterRegistration) -> SupplementaryProvider
    func makeDataSource(collectionView: UICollectionView) -> DataSource
}

public protocol ListControllerContainer: Container
{
}

public class ListControllerBuilder<S: Hashable & Comparable, I: Hashable>: ListControllerFactory & ListControllerContainer
{
    // MARK: - Defined types
    
    typealias Section = S
    typealias Item = I
    
    // MARK: - Functions
    
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

public class ListController<S: Hashable, I: Hashable, Builder: ListControllerBuilder<S, I>>: UIViewController, UICollectionViewDelegate
{
    // MARK: - Variables
    
    var builder: Builder
    var collectionView: UICollectionView
    var dataSource: Builder.DataSource
    lazy var model: Builder.ListModel = builder.makeInitialModel()
    
    // MARK: - Initialization
    
    init(builder: Builder)
    {
        self.builder = builder
        
        let collectionView = builder.makeCollectionView()
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
        collectionView.delegate = self
        collectionView.delaysContentTouches = false
        applyModel(animated: false)
    }
    
    // MARK: - Functions
    
    func reload(animated: Bool)
    {
        model = builder.makeInitialModel()
        applyModel(animated: animated)
    }
    
    func applyModel(animated: Bool, completion: (() -> Void)? = nil)
    {
        let dispatchGroup = DispatchGroup()
        
        let sortedModel = model.sorted {
            $0.key < $1.key
        }
        
        for (section, items) in sortedModel
        {
            dispatchGroup.enter()
            
            guard let first = items.first else { continue }
            let rest = Array(items.suffix(from: 1)) // Is this efficient?
            
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<Builder.Item>()
            sectionSnapshot.append([first])
            sectionSnapshot.append(rest, to: first)
            sectionSnapshot.expand([first])
            
            dataSource.apply(
                sectionSnapshot,
                to: section,
                animatingDifferences: animated,
                completion: { dispatchGroup.leave() })
        }
        
        dispatchGroup.notify(queue: .main, execute: completion ?? { })
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // Get the entity
        // Send a message that the entity was selected
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
