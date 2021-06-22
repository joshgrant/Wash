//
//  InflowsHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import ProgrammaticUI

class InflowsHeaderViewModel: TableHeaderViewModel
{
    // MARK: - Initialization
    
    convenience init()
    {
        self.init(title: "Inflows".localized)
    }
}
