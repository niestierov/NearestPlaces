//
//  NetworkService.swift
//  NearestPlaces
//
//  Created by Denys Niestierov on 09.11.2023.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol: AnyObject {
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
        guard let urlString = endpoint.fullURLString(),
              let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        AF.request(
            url,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.headers
        ).responseDecodable(of: type) { response in
            guard response.data != nil else {
                completion(.failure(NetworkError.invalidData))
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

private enum NetworkError: Error {
    case invalidURL
    case invalidData
}
