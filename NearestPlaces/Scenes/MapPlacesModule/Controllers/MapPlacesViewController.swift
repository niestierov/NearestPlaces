//
//  MapPlacesViewController.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import UIKit
import GoogleMaps

final class MapPlacesViewController: UIViewController {
    private enum Constant {
        static let navigationControllerTitle = "Map"
        static let showListPlacesImage = "list.clipboard"
        static let defaultZoom: Float = 12
        
        enum NavigationAppearence {
            static let opacity: CGFloat = 0.9
            static let whiteWithAlphaComponent = UIColor.white.withAlphaComponent(opacity)
            static let boldFontSize = UIFont.boldSystemFont(ofSize: 20)
            static let defaultTitleColor = UIColor.black
        }
    }
    
    // MARK: - Properties -
    
    private let locationService = LocationService()
    private let networkService = NetworkService()
    private var placesList: [Place] = []
    
    // MARK: - UIComponents -
    
    private var mapView: GMSMapView = {
        let map = GMSMapView()
        map.settings.myLocationButton = true
        map.isMyLocationEnabled = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    private lazy var showListPlacesButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.target = self
        button.image = UIImage(systemName: Constant.showListPlacesImage)
        return button
    }()
    
    // MARK: - LifeCycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupMapView()
        setupLocationService()
    }
}

private extension MapPlacesViewController {
    func setupLocationService() {
        locationService.delegate = self
        locationService.verifyLocationPermissions()
        locationService.showAuthorizationDeniedAlert = { alert in
            self.showAlert(
                title: alert.title,
                message: alert.message,
                actions: alert.actions
            )
        }
        locationService.showTryAgainAlert = { title, message, action in
            self.showTryAgainAlert(message: message, action: action)
        }
    }
    
    func setupNavigationBar() {
        title = Constant.navigationControllerTitle
        navigationItem.rightBarButtonItem = showListPlacesButton
        
        navigationController?.setNavigationControllerAppearance(
            opacity: Constant.NavigationAppearence.opacity,
            backgroundColor: Constant.NavigationAppearence.whiteWithAlphaComponent,
            titleColor: Constant.NavigationAppearence.defaultTitleColor,
            titleFont: Constant.NavigationAppearence.boldFontSize
        )
    }
    
    func setupMapView() {
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func updateMap(
        location: CLLocationCoordinate2D,
        zoom: Float = Constant.defaultZoom
    ) {
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: zoom)
        mapView.camera = camera
        
        fetchPlaces(location: location)
    }
    
    func fetchPlaces(location: CLLocationCoordinate2D) {
        let endpoint = Endpoint.searchNearby(
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        networkService.request(
            endpoint: endpoint,
            type: NearbySearchResponse.self
        ) { [weak self] response in
            guard let self else {
                return
            }
            
            switch response {
            case .success(let data):
                self.handleSuccessRequest(data: data)
            case .failure(let error):
                self.showTryAgainAlert(message: error.localizedDescription)
                break
            }
        }
    }
    
    func handleSuccessRequest(data: NearbySearchResponse?) {
        guard let safeData = data,
              let dataResults = safeData.places else {
            return
        }

        addMarkers(for: dataResults)
        
        placesList.append(contentsOf: dataResults)
    }
    
    func addMarkers(for places: [Place]) {
        DispatchQueue.main.async {
            for place in places {
                self.addMarker(for: place)
            }
        }
    }
    
    func addMarker(for place: Place) {
        let latitude = place.location.latitude
        let longitude = place.location.longitude
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let marker = GMSMarker(position: location)
        
        let name = place.displayName?.text ?? ""
        let address = place.formattedAddress ?? ""
        
        marker.title = name
        marker.snippet = address
        marker.map = mapView
    }
}

extension MapPlacesViewController: LocationServiceDelegate {
    func locationService(_ locationService: LocationService, didUpdateLocation location: CLLocationCoordinate2D) {
        updateMap(location: location)
    }
}
