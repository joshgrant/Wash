//
//  ConfigurableTableViewCellProtocol.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import Foundation

public protocol ConfigurableTableViewCellProtocol
{
    associatedtype TVCM
    
    func configure(with viewModel: TVCM)
}
