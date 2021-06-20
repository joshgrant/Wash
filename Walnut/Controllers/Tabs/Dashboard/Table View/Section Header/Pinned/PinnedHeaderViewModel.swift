//
//  PinnedHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation
import ProgrammaticUI

class PinnedHeaderViewModel: TableHeaderViewModel
{
    convenience init()
    {
        self.init(
            title: "Pinned".localized,
            icon: .pin)
    }
}
