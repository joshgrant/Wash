//
//  IdealInfoCell.swift
//  Walnut
//
//  Created by Joshua Grant on 6/20/21.
//

import Foundation
import UIKit

class InfoCellModel: TableViewCellModel
{
    // MARK: - Variables
    
    let title: String
    let detail: String
    
    // MARK: - Initialization
    
    required init(title: String, detail: String)
    {
        self.title = title
        self.detail = detail
    }
    
    static var cellClass: AnyClass { InfoCell.self }
}

class InfoCell: TableViewCell<InfoCellModel>
{
    // MARK: - Initialization
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?)
    {
        super.init(
            style: .value1,
            reuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Configuration
    
    override func configure(with model: InfoCellModel)
    {
        textLabel?.text = model.title
        detailTextLabel?.text = model.detail
        
        accessoryType = .detailButton
    }
}
