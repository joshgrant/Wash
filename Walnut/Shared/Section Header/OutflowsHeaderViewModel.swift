//
//  OutflowsHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import ProgrammaticUI

class OutflowsHeaderViewModel: TableHeaderViewModel
{
    // MARK: - Initialization
    
    convenience init()
    {
        self.init(title: "Outflows".localized)
    }
}
