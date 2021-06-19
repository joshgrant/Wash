//
//  TableView.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

open class TableView<TVM: TableViewModel>: UITableView
{
    // MARK: - Variables
    
    var model: TVM?
    
    // MARK: - Initialization
    
    public required init(model: TVM)
    {
        self.model = model
        
        super.init(frame: .zero, style: model.style)
        
        model.cellModelTypes.forEach
        {
            register($0.cellClass, forCellReuseIdentifier: $0.cellReuseIdentifier)
        }
        
        delegate = model.delegate
        dataSource = model.dataSource
    }
    
    @available(*, unavailable)
    public override init(frame: CGRect, style: UITableView.Style)
    {
        super.init(frame: frame, style: style)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder)
    {
        fatalError("Load this view programmatically")
    }
}
