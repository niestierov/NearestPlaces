//
//  PlacesListPresenter.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 24.11.2023.
//

import Foundation

protocol PlacesListPresenter {
    func place(at index: Int) -> Place
    func numberOfPlaces() -> Int
}

final class DefaultPlacesListPresenter: PlacesListPresenter {
    
    // MARK: - Properties -
    
    private let router: Router
    private weak var view: PlacesListView?
    private let placesList: [Place]
    
    //MARK: - Life Cycle -
    
    required init(router: Router, placesList: [Place]) {
        self.router = router
        self.placesList = placesList
    }
    
    // MARK: - Internal -
    
    func setView(_ view: PlacesListView) {
        self.view = view
    }
    
    func place(at index: Int) -> Place {
        placesList[index]
    }
    
    func numberOfPlaces() -> Int {
        placesList.count
    }
}
