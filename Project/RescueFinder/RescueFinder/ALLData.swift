import Foundation

//[
// {
//   "FIELD1": "강원도",
//   "FIELD2": "홍천군",
//   "FIELD3": "연봉리 계열사 앞",
//   "FIELD4": "강원도 홍천군 홍천읍 연봉리 262-5",
//   "FIELD5": "37.68668359999999",
//   "FIELD6": 127.8782378,
//   "FIELD7": "2022-07-20"
// },

struct Rescue : Codable {
    let FIELD1: String      // 도
    let FIELD2: String      // 시군구
    let FIELD3: String?     // 주변위치
    let FIELD4: String      // 상세주소
    let FIELD5: String      // 위도
    let FIELD6: Double      // 경도
    let FIELD7: String      // 데이터 최신화 날짜
}

struct Hospital : Codable {
    let FIELD1: String
}

struct WeatherResponse: Decodable {
    let timezone: String
    let current: Current
    let hourly: Hourly
}

struct Current : Decodable{
    let temp: Double
    let feels_like: Double
    let wind_speed: Double
    let weather: [Weather]
}

struct Weather: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct Hourly: Decodable {
    let hourly_weather: [Weather]
}

//var currentWeather: Current?
//    var temperature: Double = 0.0
//    var icon: String = ""
//    let weatherLabel = UILabel()
//    let weatherImage = UIImageView()
//    
//    loadView() / viewDidLoad() 이용해 view를 만들어주고
//
//    override func viewWillAppear(_ animated: Bool) {
//        fetchWeather()
//    }
//
//    func fetchWeather() {
//        WeatherService().getWeather { result in
//            switch result {
//            case .success(let weatherResponse):
//                DispatchQueue.main.async {
//                    self.currentWeather = weatherResponse.current
//                    self.temperature = self.currentWeather?.temp ?? 0.0
//                    self.weatherLabel.text = "temp: \(self.temperature)"
//                    self.weatherImage.image = UIImage(named: self.currentWeather?.weather[0].icon ?? "01d")
//                }
//            case .failure(_ ):
//                print("error")
//            }
//        }
//    }
//출처: https://hongssup.tistory.com/33 [Outgoing Introvert:티스토리]
