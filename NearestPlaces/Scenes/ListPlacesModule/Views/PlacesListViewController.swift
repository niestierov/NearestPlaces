//
//  ListPlacesViewController.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 10.11.2023.
//

import UIKit

protocol PlacesListView: AnyObject { }

final class PlacesListViewController: UIViewController {
    
    // MARK: - Properties -
    
    private let presenter: PlacesListPresenter!
    
    // MARK: - UI Components -
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.allowsSelection = false
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    // MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
    }
    
    init(presenter: PlacesListPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - PlacesListViewProtocol -

extension PlacesListViewController: PlacesListView { }

// MARK: - Private -

private extension PlacesListViewController {
    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupTableView() {
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tableView.register(PlaceListTableViewCell.self)
    }
}

// MARK: - UITableViewDataSource -

extension PlacesListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return presenter.numberOfPlaces()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeue(
            cellType: PlaceListTableViewCell.self,
            at: indexPath
        )
        
        let place = presenter.place(at: indexPath.row)
        
        cell.configure(place: place)
        
        return cell
    }
}
