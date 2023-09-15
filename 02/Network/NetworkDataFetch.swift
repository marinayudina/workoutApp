//
//  NetworkDataFetch.swift
//  02
//
//  Created by Марина on 12.08.2023.
//

import Foundation

class NetworkDataFetch {
    static let shared = NetworkDataFetch()
    private init() {}
    
    func fetchWeather(responce: @escaping (WeatherModel?, Error?) -> Void) {
        
        NetworkRequest.shared.requestData { result in
            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                    responce(weather, nil)
                    
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError) //ошибка с декодированием
                }
            case .failure(let error):
                print(error.localizedDescription)
                responce(nil, error) // ошибка получения данных 
            }
        }
        
    }
}
