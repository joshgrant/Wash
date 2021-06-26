//
//  IdealInfoCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit

class IdealInfoCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    let title: String = "Ideal".localized
    var percentage: Int
    var infoAction: ActionClosure? // TODO: Not optional, or use convenience
    
    // MARK: - Initialization
    
    required init(percentage: Int, infoAction: ActionClosure?)
    {
        self.percentage = percentage
        self.infoAction = infoAction
    }
    
    static var cellClass: AnyClass { IdealInfoCell.self }
}

class IdealInfoCell: TableViewCell<IdealInfoCellModel>
{
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Configuration
    
    override func configure(with model: IdealInfoCellModel)
    {
        textLabel?.text = model.title
        detailTextLabel?.text = "\(model.percentage)%"
        
        accessoryType = .detailButton
    }
}
