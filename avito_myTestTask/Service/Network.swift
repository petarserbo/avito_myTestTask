//
//  Network.swift
//  avito_myTestTask
//
//  Created by Petar Perich on 31.08.2021.
//

import Foundation


class NetworkService {
    
    func request(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
    }
}

class DataFetcher {
    
    let networkService = NetworkService()
    
    func fetchData(response: @escaping (Avito?) -> Void) {
        networkService.request(url: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c") { (result) in
            switch result {
            case .success(let data):
                do {
                    let tracks = try JSONDecoder().decode(Avito.self, from: data)
                    response(tracks)
                } catch let jsonError {
                    print("Failed to decode", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                response(nil)
            }
        }
    }
    
}
