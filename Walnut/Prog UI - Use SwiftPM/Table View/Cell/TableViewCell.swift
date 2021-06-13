//
//  TableViewCell.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

open class TableViewCell: UITableViewCell
{
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder)
    {
        fatalError("Load this view programmatically")
    }
}

extension TableViewCell: ConfigurableTableViewCellProtocol
{
    open func configure(with viewModel: TableViewCellModel)
    {
        assertionFailure("Failed to properly configure the table view cell.")
    }
}
