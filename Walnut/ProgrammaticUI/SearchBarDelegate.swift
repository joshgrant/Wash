//
//  SearchBarDelegateProtocol.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 9/26/20.
//

import UIKit

public typealias SearchBarDelegateType = NSObject & UISearchBarDelegate

// MARK: - Protocol

public protocol SearchBarDelegateProtocol: SearchBarDelegateType
{
    func configure(searchBar: UISearchBar)
}

public extension SearchBarDelegateProtocol
{
    func configure(searchBar: UISearchBar)
    {
        searchBar.delegate = self
    }
}

// MARK: - Delegate

open class SearchBarDelegate: NSObject, SearchBarDelegateProtocol
{
    
}
