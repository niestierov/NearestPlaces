//
//  PlacesListPresenter.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 24.11.2023.
//

import Foundation

protocol PlacesListPresenter {
    var placesList: [Place] { get }
}

final class DefaultPlacesListPresenter: PlacesListPresenter {
    
    // MARK: - Properties -
    
    private let router: Router
    private weak var view: PlacesListView?
    private(set) var placesList: [Place] = []
    
    //MARK: - Life Cycle -
    
    required init(router: Router, placesList: [Place]) {
        self.router = router
        self.placesList = placesList
    }
    
    // MARK: - Internal -
    
    func setView(_ view: PlacesListView) {
        self.view = view
    }
}
