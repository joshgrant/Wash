//
//  EntityListTableViewDelegate.swift
//  Walnut
//
//  Created by Joshua Grant on 6/21/21.
//

import Foundation
import ProgrammaticUI

class EntityListTableViewDelegate: TableViewDelegate
{
    
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        "Delete".localized
    }
}
