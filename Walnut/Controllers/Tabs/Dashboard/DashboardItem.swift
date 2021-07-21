//
//  DashboardListItem.swift
//  Walnut
//
//  Created by Joshua Grant on 7/20/21.
//

import Foundation
import UIKit

enum DashboardItem: Hashable
{
    case pinned(_ item: RightImageListItem)
    case suggestedFlow(_ item: SubtitleCheckboxListItem)
}
