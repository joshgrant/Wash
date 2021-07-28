//
//  SymbolTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation
import UIKit

protocol SymbolTableViewFactory: Factory
{
    // TODO: Every table view factory should make the table view...
    func makeTableView() -> TableView<SymbolTableViewContainer>
    func makeModel() -> TableViewModel
    func makeInfoSection() -> TableViewSection
    func makeReferencesSection() -> TableViewSection
    func makeLinkSection() -> TableViewSection
}

class SymbolTableViewContainer: TableViewContainer
{
    // MARK: - Variables
    
    var symbol: Symbol
    var stream: Stream
    var style: UITableView.Style
    lazy var model: TableViewModel = makeModel()
    
    // MARK: - Initialization
    
    init(symbol: Symbol, stream: Stream, style: UITableView.Style)
    {
        self.symbol = symbol
        self.stream = stream
        self.style = style
    }
}

extension SymbolTableViewContainer: SymbolTableViewFactory
{
    func makeTableView() -> TableView<SymbolTableViewContainer>
    {
        .init(container: self)
    }
    
    func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection(),
            makeReferencesSection(),
            makeLinkSection()
        ])
    }
    
    func makeInfoSection() -> TableViewSection
    {
        let models: [TableViewCellModel] = [
            // Replaced with the TextEditItem
//            TextEditCellModel(
//                selectionIdentifier: .title,
//                text: symbol.name,
//                placeholder: "Name",
//                entity: symbol,
//                stream: stream)
        ]
        
        return TableViewSection(
            header: .info,
            models: models)
    }
    
    func makeReferencesSection() -> TableViewSection
    {
        let entities = [
            symbol.nameOfColor,
            symbol.nameOfFlow,
            symbol.nameOfEvent,
            symbol.nameOfState,
            symbol.nameOfStock,
            symbol.nameOfSystem,
            symbol.nameOfCondition,
            symbol.nameOfConversion
        ]
        
        let models = entities
            .compactMap { $0 as? NamedEntity }
            .map { named in
                RightImageCellModel(
                    selectionIdentifier: .entity(entity: named),
                    title: named.title,
                    detail: EntityType.type(from: named)?.icon ?? .question,
                    disclosure: true)
            }
        
        return TableViewSection(
            header: .references,
            models: models)
    }
    
    func makeLinkSection() -> TableViewSection
    {
        let entities: [Entity] = symbol.unwrapped(\Symbol.linkedEntities)
        
        let models: [TableViewCellModel] = entities.compactMap { named in
            guard let named = named as? NamedEntity else { return nil }
            // TODO: Need a subtitle here to show how many links there are?
            return RightImageCellModel(
                selectionIdentifier: .link(link: named),
                title: named.title,
                detail: EntityType.type(from: named)?.icon ?? .question,
                disclosure: true)
        }
        
        return TableViewSection(
            header: .links,
            models: models)
    }
}
