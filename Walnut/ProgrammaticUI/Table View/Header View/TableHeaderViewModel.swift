//
//  TableHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

open class TableHeaderViewModel: ViewModel
{
    // MARK: - Variables
    
    public var title: String
    public var icon: Icon?
    
    public var disclosureTriangleActionClosure: ActionClosure?
    public var searchButtonActionClosure: ActionClosure?
    public var linkButtonActionClosure: ActionClosure?
    public var addButtonActionClosure: ActionClosure?
    public var editButtonActionClosure: ActionClosure?
    
    public var hasDisclosureTriangle: Bool { disclosureTriangleActionClosure != nil }
    public var hasSearchButton: Bool { searchButtonActionClosure != nil }
    public var hasLinkButton: Bool { linkButtonActionClosure != nil }
    public var hasAddButton: Bool { addButtonActionClosure != nil }
    public var hasEditButton: Bool { editButtonActionClosure != nil }
    
    public var editButtonTitle: String { "Edit".localized }
    
    // MARK: - Initialization
    
    public init(title: String)
    {
        self.title = title
    }
    
    public init(title: String, icon: Icon)
    {
        self.title = title
        self.icon = icon
    }
}
