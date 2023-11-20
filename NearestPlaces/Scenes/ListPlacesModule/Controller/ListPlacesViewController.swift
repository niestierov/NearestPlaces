//
//  ListPlacesViewController.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 10.11.2023.
//

import UIKit

final class ListPlacesViewController: UIViewController {

    // MARK: - Properties -
    
    private var placesList: [Place] = []
    
    // MARK: - UIComponents -
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.allowsSelection = false
        return table
    }()
    
    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
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

private extension ListPlacesViewController {
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        tableView.register(ListPlaceTableViewCell.self)
    }
}

extension ListPlacesViewController: UITableViewDataSource {
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
            cellType: ListPlaceTableViewCell.self,
            at: indexPath
        )
        
        cell.configure(place: placesList[indexPath.row])
        
        return cell
    }
}

extension ListPlacesViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
}
