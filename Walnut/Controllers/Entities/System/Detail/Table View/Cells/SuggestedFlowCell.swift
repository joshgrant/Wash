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
    
    var title: String
    
    // MARK: - Initialization
    
    init(title: String)
    {
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
