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
    let FIELD1: String
    let FIELD2: String
    let FIELD3: String?
    let FIELD4: String
    let FIELD5: String
    let FIELD6: Double
    let FIELD7: String
}
