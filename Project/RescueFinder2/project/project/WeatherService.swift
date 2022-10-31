//
//"부산광역시":[
//    {
//       "계곡명":"대천천계곡",
//       "주소":"북구 화명동 2102"
//       "운영시간":"",
//       "전화번호":"의원",
//       "입장료":"갈바리의원",
//       "위험도":"재단법인",
//       "깊이":3,
//    },
//    {
//        "계곡명":"장안사계곡",
//        "주소":"기장군 장안읍 장안리 664-21"
//        "운영시간":"",
//        "연락처":"의원",
//        "입장료":"갈바리의원",
//        "위험도":"재단법인",
//        "깊이":3,
//    },
//    {
//        "계곡명":"용소천계곡",
//        "주소":"기장군 장안읍 용소리 581"
//        "운영시간":"",
//        "연락처":"의원",
//        "입장료":"갈바리의원",
//        "위험도":"재단법인",
//        "깊이":3,
//    },
//    {
//        "계곡명":"장산계곡",
//        "주소":"해운대구 우동 산2"
//        "운영시간":"",
//        "연락처":"의원",
//        "입장료":"갈바리의원",
//        "위험도":"재단법인",
//        "깊이":3,
//    },
//]
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
    
    var weatherResponse: WeatherResponse!
    var cur_lat: Double = 0.0
    var cur_lng: Double = 0.0

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
    
    func getLoc(lat1: Double, lng1: Double) {
        cur_lat = lat1
        cur_lng = lng1
    }
    
    func getWeather(completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        
        let request_url = "https://api.openweathermap.org/data/3.0/onecall?lat=\(cur_lat)&lon=\(cur_lng)&units=metric&exclude=minutely,daily&appid=\(apiKey)"
        print(request_url)
        let url = URL(string: request_url)
        
        guard let url = url else {
            print("badURL")
            return completion(.failure(.badUrl)) }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                print("noData")
                return completion(.failure(.noData)) }
            
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
        
            if let weatherResponse = weatherResponse { completion(.success(weatherResponse))}
            else {
                print("decodingError")
                completion(.failure(.decodingError)) }
            
            }.resume()
        }
    
    
    
}
