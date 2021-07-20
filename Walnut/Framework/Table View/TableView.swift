//
//  TableView.swift
//  ProgrammaticUI
//
//  Created by Joshua Grant on 6/6/21.
//

import UIKit

protocol TableViewDependencyContainer: DependencyContainer
{
    var model: TableViewModel { get set }
    var stream: Stream { get set }
    var style: UITableView.Style { get }
}

class TableView<Container: TableViewDependencyContainer>: UITableView, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - Variables
    
    var container: Container
    
    var shouldReload: Bool = false
    {
        didSet
        {
            if shouldReload
            {
                guard let _ = window else { return }
                reload()
            }
        }
    }
    
    // MARK: - Initialization
    
    required init(container: Container)
    {
        self.container = container
        super.init(frame: .zero, style: container.style)
        container.model = makeModel()
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func didMoveToWindow()
    {
        super.didMoveToWindow()
        guard let _ = window else { return }
        
        if shouldReload
        {
            reload()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        
        for touch in touches
        {
            if touch.view == self
            {
                endEditing(true)
                return
            }
        }
    }
    
    func reload(shouldReloadTableView: Bool = true)
    {
        container.model = makeModel() // TODO: Maybe do a diff?
        configure()
        
        if shouldReloadTableView
        {
            reloadData()
        }
        
        shouldReload = false
    }
    
    // MARK: - Configuration
    
    func makeModel() -> TableViewModel
    {
        fatalError("Implement in subclass")
    }
    
    func configure()
    {
        for type in container.model.cellModelTypes
        {
            register(type.cellClass, forCellReuseIdentifier: type.cellReuseIdentifier)
        }
        
        dataSource = self
        delegate = self
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cellModel = container.model.models[indexPath.section][indexPath.row]
        let message = TableViewSelectionMessage(tableView: tableView, cellModel: cellModel)
        container.stream.send(message: message)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        container.model.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        container.model.models[section].count
    }
    
    // MARK: Cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model = container.model.models[indexPath.section][indexPath.row]
        return model.makeCell(in: tableView, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let model = container.model.models[indexPath.section][indexPath.row]
        
        // TODO: Table view should not know about special cells
        // Cells should suggest sizing here
        switch model
        {
        case is SubtitleDetailCellModel:
            fallthrough
        case is FlowDetailCellModel:
            return 60
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.tableView(tableView, estimatedHeightForRowAt: indexPath)
    }
    
    // MARK: Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        guard let headerModel = container.model.headers[section] else { return nil }
        return TableHeaderView(model: headerModel)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat
    {
        guard let _ = container.model.headers[section] else { return 1 }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        guard let _ = container.model.headers[section] else { return 0 }
        return 44
    }
    
    // MARK: Footer
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        return container.model.footers[section]
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat
    {
        guard let _ = container.model.footers[section] else { return 1 }
        return 38
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        guard let _ = container.model.footers[section] else { return 0 }
        return 38
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        nil
    }
}
