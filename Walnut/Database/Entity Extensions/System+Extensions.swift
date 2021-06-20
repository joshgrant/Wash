//
//  System+Extensions.swift
//  Schema
//
//  Created by Joshua Grant on 10/8/20.
//

import Foundation
import CoreData
import ProgrammaticUI

extension System: Named {}
extension System: Pinnable {}

extension System
{
    static func makeFetchRequest() -> NSFetchRequest<System>
    {
        System.fetchRequest()
    }
    
    static func allSystems(context: Context) -> [System]
    {
        let request = Self.makeFetchRequest()
        do
        {
            return try context.fetch(request)
        }
        catch
        {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
}
