//
//  SuggestedFlowCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit

class SuggestedFlowCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    var selectionIdentifier: SelectionIdentifier
    var title: String
    
    // MARK: - Initialization
    
    init(
        selectionIdentifier: SelectionIdentifier,
        title: String)
    {
        self.selectionIdentifier = selectionIdentifier
        self.title = title
    }
    
    static var cellClass: AnyClass { SuggestedFlowCell.self }
}

class SuggestedFlowCell: TableViewCell<SuggestedFlowCellModel>
{
    override func configure(with model: SuggestedFlowCellModel)
    {
        textLabel?.text = model.title
        accessoryType = .checkmark
    }
}
