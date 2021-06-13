//
//  DatabaseDelegate.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/12/21.
//

import CoreData

public protocol DatabaseDelegate: AnyObject
{
    func populate(context: Context)
}
