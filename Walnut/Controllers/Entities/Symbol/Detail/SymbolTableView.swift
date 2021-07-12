//
//  SymbolTableView.swift
//  Walnut
//
//  Created by Joshua Grant on 7/11/21.
//

import Foundation

class SymbolTableView: TableView
{
    // MARK: - Variables
    
    var symbol: Symbol
    
    // MARK: - Initialization
    
    init(symbol: Symbol)
    {
        self.symbol = symbol
        super.init()
    }
    
    // MARK: - Model
    
    override func makeModel() -> TableViewModel
    {
        TableViewModel(sections: [
            makeInfoSection(symbol: symbol),
            makeReferencesSection(symbol: symbol),
            makeLinksSection(symbol: symbol)
        ])
    }
    
    // MARK: Info
    
    func makeInfoSection(symbol: Symbol) -> TableViewSection
    {
        let models = [
            TextEditCellModel(
                selectionIdentifier: .title,
                text: symbol.name,
                placeholder: "Name",
                entity: symbol)
        ]
        
        return TableViewSection(
            header: .info,
            models: models)
    }
    
    // MARK: References
    
    func makeReferencesSection(symbol: Symbol) -> TableViewSection
    {
        let entities = [
            symbol.nameOfColor,
            symbol.nameOfFlow,
            symbol.nameOfNote,
            symbol.nameOfUnit,
            symbol.nameOfEvent,
            symbol.nameOfState,
            symbol.nameOfStock,
            symbol.nameOfSystem,
            symbol.nameOfCondition,
            symbol.nameOfDimension,
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
    
    // MARK: Links
    
    func makeLinksSection(symbol: Symbol) -> TableViewSection
    {
        let entities: [Entity] = symbol.unwrapped(\Symbol.links)
        
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
