//
//  ConfigurableTableViewCellProtocol.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Foundation

public protocol ConfigurableTableViewCellProtocol
{
    associatedtype CellModel
    func configure(with model: CellModel)
}
