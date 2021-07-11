//
//  TableView.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

class TableView: UITableView, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - Variables
    
    var model: TableViewModel
    var stream: Stream
    
    // MARK: - Initialization
    
    required init(model: TableViewModel, stream: Stream? = nil, style: UITableView.Style = .grouped)
    {
        self.model = model
        self.stream = stream ?? AppDelegate.shared.mainStream
        
        super.init(frame: .zero, style: style)
        
        configure()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    private func configure()
    {
        for type in model.cellModelTypes
        {
            register(type.cellClass, forCellReuseIdentifier: type.cellReuseIdentifier)
        }
        
        dataSource = self
        delegate = self
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cellModel = model.models[indexPath.section][indexPath.row]
        let message = TableViewSelectionMessage(tableView: tableView, cellModel: cellModel)
        stream.send(message: message)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        model.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        model.models[section].count
    }
    
    // MARK: Cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model = model.models[indexPath.section][indexPath.row]
        return model.makeCell(in: tableView, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    // MARK: Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        guard let headerModel = model.headers[section] else { return nil }
        return TableHeaderView(model: headerModel)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    {
        guard let _ = model.headers[section] else { return 1 }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        guard let _ = model.headers[section] else { return 0 }
        return 44
    }
    
    // MARK: Footer
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        return model.footers[section]
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
    {
        guard let _ = model.footers[section] else { return 1 }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        guard let _ = model.footers[section] else { return 0 }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        nil
    }
}
