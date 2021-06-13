//
//  TableHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import UIKit

public class TableHeaderViewModel: ViewModel
{
    // MARK: - Variables
    
    var title: String
    var icon: Icon?
    
    var disclosureTriangleActionClosure: ActionClosure?
    var searchButtonActionClosure: ActionClosure?
    var linkButtonActionClosure: ActionClosure?
    var addButtonActionClosure: ActionClosure?
    var editButtonActionClosure: ActionClosure?
    
    var hasDisclosureTriangle: Bool { disclosureTriangleActionClosure != nil }
    var hasSearchButton: Bool { searchButtonActionClosure != nil }
    var hasLinkButton: Bool { linkButtonActionClosure != nil }
    var hasAddButton: Bool { addButtonActionClosure != nil }
    var hasEditButton: Bool { editButtonActionClosure != nil }
    
    var editButtonTitle: String
    {
        "Edit".localized
    }
    
    // MARK: - Initialization
    
    init(title: String)
    {
        self.title = title
    }
    
    init(title: String, icon: Icon)
    {
        self.title = title
        self.icon = icon
    }
}
