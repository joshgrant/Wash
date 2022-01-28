//
//  main.swift
//  Walnut
//
//  Created by Joshua Grant on 1/16/22.
//

import Foundation
import Protyper

var database = Database()
var stream = Stream(identifier: .main)

let dashboard = NavigationController(root: DashboardViewController(context: database.context))
let library = NavigationController(root: LibraryViewController(context: database.context))

let tabBarController = MainTabBarController(tabs: [dashboard, library])
let window = Window()
window.rootViewController = tabBarController
window.makeVisible()

var loop = true

while(loop)
{
    window.update()
    
    guard let input = readLine() else { continue }
    
    switch input
    {
    case "q":
        loop = false
        print("Saving...")
        database.context.quickSave()
        print("Done! Have a nice day.")
    default:
        let command = Command(rawString: input)
        tabBarController.handle(command: command)
    }
}
/**
 
 1. Add stock (enter the values we want the stock to have
 2. Delete stock
 3. Edit stock (choose which properties to edit?)
 a. Ability to link flows, notes, etc
 b. Set the current value, ideal value, etc
 4. View stock (see all the relevant properties)
 5. List all stocks (and be able to select which we need
 6. Pin / unpin a stock
 
 ---
 
 Different tabs (dashboard, library, inbox (which is... what exactly?), settings?...
 
 Dashboard just prints out:
 1. All of the pinned items
 2. Upcoming events (in real-time?? v. simulated time??)
 3. All of the high-priority unbalanced stocks
 4. All of the currently active flows???? If this is possible... Or flow queue?
 
 Typing a number in the dashboard lets us jump to that item (like selecting the table view item)
 Typing a number, followed by a command (unpin, pin, delete etc) is like swiping right on the table view cell
 
 ----
 
 Library prints out:
 1. All of the different types
 2. The count for each of the types
 
 Typing a number in the library tab takes us to that library option (like selecting that item in the table view)
 Typing a number followed by a command (add) is like swiping right on that table view cell)
 
 ----
 
 Detail screens
 
 1. Prints out all of the information about that item
 2. For different sections (flows, for example) include numbers that we can type to "select" that row
 a. Followed by a command, if necessary (i.e unlink)
 3. Allow a set of commands (edit, pin, unpin, delete, run) at the top-level. So, we need some sort of "context" which represents the screen and which actions we can take
 4.
 
 */
