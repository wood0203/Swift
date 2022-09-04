//
//  WeatherService.swift
//  RescueFinder2
//
//  Created by 1 on 2022/09/02.
//

import Foundation

// 오류에 대한 열거형 자료형
enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

class WeatherService {
    
    var crnt_lat: Double = 0.0
    var crnt_lng: Double = 0.0
    
    init(lat: Double, lng: Double) {
        crnt_lat = lat
        crnt_lng = lng
    }
    
    private var apiKey: String {
            get {
                // 생성한 .plist 파일 경로 불러오기
                guard let filePath = Bundle.main.path(forResource: "Property List", ofType: "plist") else {
                    fatalError("Couldn't find file 'Property List.plist'.")
                }
                
                // .plist를 딕셔너리로 받아오기
                let plist = NSDictionary(contentsOfFile: filePath)
                
                // 딕셔너리에서 값 찾기
                guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else {
                    fatalError("Couldn't find key 'OPENWEATHERMAP_KEY' in 'KeyList.plist'.")
                }
                return value
            }
        }
    
    func getWeather(completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
    
        let request_url = "https://api.openweathermap.org/data/3.0/onecall?lat=" + String(crnt_lat) + "&lon=" + String(crnt_lng) + "&exclude=minutely,daily,alerts&appid=0640b95f418fe69e7c7a882c71d17482"
        let url = URL(string: request_url)
        guard let url = url else { return completion(.failure(.badUrl)) }
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return completion(.failure(.noData)) }
            
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
            if let weatherResponse = weatherResponse { completion(.success(weatherResponse))
            } else { completion(.failure(.decodingError)) }
        
        }.resume()
    }
}

