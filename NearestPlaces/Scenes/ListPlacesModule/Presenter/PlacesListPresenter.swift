//
//  PlacesListPresenter.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 24.11.2023.
//

import Foundation

protocol PlacesListPresenterProtocol {
    var placesList: [Place] { get }
}

final class PlacesListPresenter: PlacesListPresenterProtocol {
    
    // MARK: - Properties -
    
    private weak var view: PlacesListViewProtocol?
    private(set) var placesList: [Place] = []
    
    //MARK: - Life Cycle -
    
    required init(placesList: [Place]) {
        self.placesList = placesList
    }
    
    // MARK: - Internal -
    
    func inject(view: PlacesListViewProtocol) {
        self.view = view
    }
}
