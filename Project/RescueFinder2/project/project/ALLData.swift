import Foundation


struct Rescue : Codable {
    let FIELD1: String      // 도
    let FIELD2: String      // 시군구
    let FIELD3: String?     // 주변위치
    let FIELD4: String      // 상세주소
    let FIELD5: String      // 위도
    let FIELD6: Double      // 경도
    let FIELD7: String      // 데이터 최신화 날짜
}

struct rescue: Comparable {
    var distance: Double
    var address: String
    var latitude: Double
    var longitude: Double
    
    static func < (lhs: rescue, rhs: rescue) -> Bool {
        return lhs.distance < rhs.distance
    }
}

struct Hospital : Codable {
    let 의료기관명: String
    let 연락처: String
    let 소재지도로명주소: String
    let 경도: Double
    let 위도: Double
}

struct hospital: Comparable {
    var distance: Double
    var address: String
    var phone_num: String
    var name: String
    var latitude: Double
    var longitude: Double
    
    static func < (lhs: hospital, rhs: hospital) -> Bool {
        return lhs.distance < rhs.distance
    }
}

struct WeatherResponse: Decodable {
    let timezone: String
    let current: Current
    let hourly: [Hourly]
}

struct Current : Decodable {
    let dt: Int
    let temp: Double
    let uvi: Double
    let weather: [Weather]
}

struct Weather: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct Hourly: Decodable {
    let dt: Int
    let temp: Double
    let uvi: Double
    let weather: [Weather]
}
