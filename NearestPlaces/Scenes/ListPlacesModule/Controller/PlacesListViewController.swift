//
//  ListPlacesViewController.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 10.11.2023.
//

import UIKit

final class PlacesListViewController: UIViewController {

    // MARK: - Properties -
    
    private var placesList: [Place] = []
    
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
    
    init(placesList: [Place]) {
        self.placesList = placesList
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

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

extension PlacesListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return placesList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeue(
            cellType: PlaceListTableViewCell.self,
            at: indexPath
        )
        
        cell.configure(place: placesList[indexPath.row])
        
        return cell
    }
}
