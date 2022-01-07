//
//  UnitDetailController.swift
//  Walnut
//
//  Created by Joshua Grant on 7/28/21.
//

import UIKit

enum UnitDetailSection: Hashable
{
    case info
}

enum UnitDetailItem: Hashable
{
    case header(HeaderItem)
    case name(TextEditItem)
    case abbreviation(TextEditItem)
    case baseUnit(ToggleItem)
    case relativeTo(DetailItem)
}

extension UnitDetailItem: Identifiable
{
    var id: UUID
    {
        switch self
        {
        case .header(let item): return item.id
        case .name(let item): return item.id
        case .abbreviation(let item): return item.id
        case .baseUnit(let item): return item.id
        case .relativeTo(let item): return item.id
        }
    }
}

protocol UnitDetailFactory: Factory
{
    func makeController() -> UnitDetailController
    func makeRouter() -> UnitDetailRouter
}

class UnitDetailBuilder: ListControllerBuilder<UnitDetailSection, UnitDetailItem>
{
    // MARK: - Variables
    
    var unit: Unit
    
    var context: Context
    var stream: Stream
    
    weak var toggleDelegate: ToggleItemDelegate?
    weak var textDelegate: UITextFieldDelegate?
    weak var routerDelegate: RouterDelegate?
    
    // MARK: - Initialization
    
    init(unit: Unit, context: Context, stream: Stream)
    {
        self.unit = unit
        self.context = context
        self.stream = stream
    }
    
    // MARK: - Functions
    
    func makeController() -> UnitDetailController
    {
        .init(builder: self)
    }
    
    func makeRouter() -> UnitDetailRouter
    {
        .init(unit: unit, context: context, stream: stream, delegate: routerDelegate)
    }
    
    override func makeCellProvider() -> ListControllerBuilder<UnitDetailSection, UnitDetailItem>.CellProvider
    {
        { collectionView, indexPath, item in
            switch item
            {
            case .header(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: type(of: item).registration,
                    for: indexPath,
                    item: item)
            case .name(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: type(of: item).registration,
                    for: indexPath,
                    item: item)
            case .abbreviation(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: type(of: item).registration,
                    for: indexPath,
                    item: item)
            case .baseUnit(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: type(of: item).registration,
                    for: indexPath,
                    item: item)
            case .relativeTo(let item):
                return collectionView.dequeueConfiguredReusableCell(
                    using: type(of: item).registration,
                    for: indexPath,
                    item: item)
            }
        }
    }
    
    override func makeInitialModel() -> ListControllerBuilder<UnitDetailSection, UnitDetailItem>.ListModel
    {
        [
            .info: makeInfoItems()
        ]
    }
    
    private func makeInfoItems() -> [UnitDetailItem]
    {
        var items: [UnitDetailItem] = []
        
        items.append(.header(.init(text: .info)))
        items.append(.name(.init(
                            text: unit.title,
                            placeholder: .title,
                            keyboardType: .default,
                            tag: UnitDetailController.TextFieldType.title.rawValue,
                            delegate: textDelegate)))
        items.append(.abbreviation(.init(
                                    text: unit.abbreviation,
                                    placeholder: .abbreviation,
                                    keyboardType: .default,
                                    tag: UnitDetailController.TextFieldType.abbreviation.rawValue,
                                    delegate: textDelegate)))
        items.append(.baseUnit(.init(
                                text: .baseUnit,
                                isOn: unit.isBase,
                                delegate: toggleDelegate)))
        
        if !unit.isBase, let parent = unit.parent
        {
            items.append(.relativeTo(.init(text: parent.title)))
        }
        
        return items
    }
}

class UnitDetailController: ListController<UnitDetailSection, UnitDetailItem, UnitDetailBuilder>
{
    // MARK: - Defined types
    
    enum TextFieldType: Int
    {
        case title
        case abbreviation
    }
    
    // MARK: - Variables
    
    var id = UUID()
    
    lazy var router: UnitDetailRouter = builder.makeRouter()
    
    // MARK: - Initialization
    
    override init(builder: UnitDetailBuilder)
    {
        super.init(builder: builder)
        
        subscribe(to: builder.stream)
        
        builder.toggleDelegate = self
        builder.textDelegate = self
        builder.routerDelegate = self
        
        title = builder.unit.title
    }
    
    deinit
    {
        unsubscribe(from: builder.stream)
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
        router.routeToLinkUnit(linkDelegate: self)
        super.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}

extension UnitDetailController: Subscriber
{
    func receive(message: Message)
    {
        
    }
}

extension UnitDetailController: ToggleItemDelegate
{
    @objc func toggleDidChangeValue(_ toggle: UISwitch)
    {
        builder.unit.isBase = toggle.isOn
        
        if toggle.isOn
        {
            removeRelativeItem()
        }
        else
        {
            addRelativeItem(unit: builder.unit)
        }
        
        applyModel(animated: true)
    }
    
    func addRelativeItem(unit: Unit)
    {
        let relativeItem = UnitDetailItem.relativeTo(.init(text: unit.parent?.title ?? ""))
        model[.info]?.append(relativeItem)
    }
    
    func removeRelativeItem()
    {
        model[.info] = model[.info]?.filter { item in
            switch item
            {
            case .relativeTo:
                return false
            default:
                return true
            }
        }
    }
}

extension UnitDetailController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let type = TextFieldType(rawValue: textField.tag)!
        
        switch type
        {
        case .title:
            builder.unit.title = textField.text ?? builder.unit.title // Save the title
            title = textField.text // Update the controller title
        case .abbreviation:
            builder.unit.abbreviation = textField.text ?? builder.unit.abbreviation // Save the abbreviation
        }
        
        builder.context.quickSave()
    }
}

extension UnitDetailController: RouterDelegate { }

extension UnitDetailController: LinkSearchControllerDelegate
{
    func didSelectEntity(entity: Entity, controller: LinkSearchController)
    {
        guard let parent = entity as? Unit else { fatalError() }
        builder.unit.parent = parent
        navigationController?.popViewController(animated: true)
    }
}
