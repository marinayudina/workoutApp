//
//  NetworkRequest.swift
//  02
//
//  Created by Марина on 12.08.2023.
//

import Foundation

class NetworkRequest {
    static let shared = NetworkRequest()
    private init() {}
    
    func requestData(completion: @escaping (Result<Data, Error>) -> Void) {
        let key = "46e3508961e0b0eb610f5a6bbff32205"
        let latitude = 55.652816
        let longitude = 37.407681
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(key)"
        
        guard let url = URL(string: urlString) else {return}
   
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        .resume()
    }
}
