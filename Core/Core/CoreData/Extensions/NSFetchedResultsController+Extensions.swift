//
//  NSFetchedResultsController+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 7/9/21.
//

import Foundation
import CoreData

extension NSFetchedResultsController
{
    @objc func item(at indexPath: IndexPath) -> Any?
    {
        return sections?[indexPath.section].objects?[indexPath.row]
    }
}
