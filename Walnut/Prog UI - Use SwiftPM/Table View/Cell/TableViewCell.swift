//
//  TableViewCell.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

open class TableViewCell<TVCM: TableViewCellModel>: UITableViewCell, ConfigurableTableViewCellProtocol
{
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder)
    {
        fatalError("Load this view programmatically")
    }

    /// This can't be in an extension because the compiler won't
    /// allow it to be overridden
    open func configure(with viewModel: TVCM)
    {
        assertionFailure("Failed to properly configure the table view cell.")
    }
}
