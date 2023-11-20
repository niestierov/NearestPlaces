//
//  UITableView + Reusable.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 17.11.2023.
//

import UIKit

extension UITableViewCell: Reusable { }

extension UITableView {
    func register(_ cellType: Reusable.Type) {
        register(cellType.self, forCellReuseIdentifier: cellType.identifier)
    }

    func dequeue<T: Reusable>(cellType: T.Type, at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: cellType.identifier,
            for: indexPath
        ) as? T
        else {
            fatalError("cell of type \(cellType) not registered")
        }
        return cell
    }
}
