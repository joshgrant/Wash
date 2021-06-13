//
//  PinnedHeaderViewModel.swift
//  Walnut
//
//  Created by Joshua Grant on 6/13/21.
//

import Foundation

class PinnedHeaderViewModel: TableHeaderViewModel
{
    convenience init()
    {
        self.init(
            title: "Pinned".localized,
            icon: .pin)
    }
}
