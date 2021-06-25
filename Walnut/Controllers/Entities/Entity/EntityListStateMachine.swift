//
//  EntityListStateMachine.swift
//  Walnut
//
//  Created by Joshua Grant on 6/23/21.
//

import Foundation
import UIKit
import ProgrammaticUI

/// Contains all of the state of the entity list view controller
struct EntityListState
{
    
}

// What is functional programming?
// What is reactive functional programming?

// How can we make our applications reactive, functional?

// A function takes inputs and produces outputs. Very testable
// We need inputs that represent desired state changes:
// - button press
// - swipe
// - network result
// These "desired" state changes modify the state of the application
// Then, the "main" part of the application takes the state
// and applies it.

// Now, we want state changes to apply only to relevant parts of the application - so we break state into a hierarchy of values - a button has it's own state, for example, and a view controller's state might contain the button's state.

// Because we don't have a "main" loop where we update the life of the application, we need to get creative...

// ----


/*
 
 Table view cell:
 state: normal, selected, trailingActions
 
 But where are the state boundaries?
 How to ensure smooth transitions? How to ensure user-reactive transitions?
 */

/// The various states of a table view cell
enum TableViewCellState
{
    case normal
    case selected
    case swiping(percent: Float)
    case leadingActions
    case trailingActions
}

/// Now, when a table view cell changes state, what do we do?
class CustomTableViewCell: UITableViewCell
{
}

func transition(from: TableViewCellState, to: TableViewCellState) -> ((UITableViewCell, [AnyHashable: Any]) -> UITableViewCell)
{
    switch (from, to)
    {
    case (_, .normal):
        return transitionToNormal
    case (_, .selected):
        return transitionToSelected
    case (_, .swiping(let percent)):
        print(percent)
        return transitionToSwiping
    case (_, .leadingActions):
        return transitionToLeadingActions
    case (_, .trailingActions):
        return transitionToTrailingActions
    }
}

//    var state: TableViewCellState = .normal
//    {
//        didSet
//        {
//            switch state
//            {
//            case .normal:
//                transitionToNormal()
//            case .selected:
//                transitionToSelected()
//            case .swiping(let percent):
//                transitionToSwiping(percent: percent)
//            case .leadingActions:
//                transitionToLeadingActions()
//            case .trailingActions:
//                transitionToLeadingActions()
//            }
//        }
//    }

// The problem about these functions is that they modify the
// state of the application...
// Rather, how to do we avoid side-effects?
// A: We take a table view cell in as a parameter
// and return a new table view cell that copies the
// original and modifies some properties (x, y / title)

// The only problem with this is that table view cells are
// classes...

func transitionToNormal(_ cell: UITableViewCell, _ userInfo: [AnyHashable: Any]) -> UITableViewCell
{
    return cell
}

func transitionToSelected(_ cell: UITableViewCell, _ userInfo: [AnyHashable: Any]) -> UITableViewCell
{
    return cell
}

func transitionToSwiping(_ cell: UITableViewCell, _ userInfo: [AnyHashable: Any]) -> UITableViewCell
{
    guard let percent = userInfo["percent"] as? Float else { return cell }
    print(percent)
    return cell
}

func transitionToLeadingActions(_ cell: UITableViewCell, _ userInfo: [AnyHashable: Any]) -> UITableViewCell
{
    return cell
}

func transitionToTrailingActions(_ cell: UITableViewCell, _ userInfo: [AnyHashable: Any]) -> UITableViewCell
{
    return cell
}
