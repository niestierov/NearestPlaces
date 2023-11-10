//
//  NetworkService.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: Endpoint,
        type: T.Type,
        completion: @escaping (Result<T?, Error>) -> Void
    )
}

final class NetworkService: NetworkServiceProtocol {
    
    func request<T: Decodable>(
        endpoint: Endpoint,
        type: T.Type,
        completion: @escaping (Result<T?, Error>) -> Void
    ) {
        guard let url = URL(string: endpoint.fullURLString()) else {
            return
        }
        
        AF.request(
            url,
            method: endpoint.method,
            encoding: endpoint.encoding
        ).responseDecodable(of: type) { response in
            guard response.data != nil else {
                completion(.failure(RequestError.invalidData))
                return
            }
            
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private enum RequestError: Error {
    case invalidURL
    case invalidData
}
