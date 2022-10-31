import Foundation


public class DataLoader {
    
    @Published var rescue_data = [Rescue]()
    @Published var hospital_data = [Hospital]()
    @Published var valley_data = [Valley]()
    
    init() {
        load(filename: "rescue_data")
        load(filename: "hospital_data")
        load(filename: "Valley_data")
    }
    
    func load(filename: String) {
        
        if let filepath = Bundle.main.url(forResource: filename, withExtension: "json") {
        
            do {
            
                let data = try Data(contentsOf: filepath)
                let jsondecoder = JSONDecoder()
                if filename == "rescue_data" {
                    let datafromjson = try jsondecoder.decode([Rescue].self, from: data)
                    self.rescue_data = datafromjson
                } else {
                    let datafromjson = try jsondecoder.decode([Hospital].self, from: data)
                    self.hospital_data = datafromjson
                }
            } catch {
                    print(error)
            }
        }
    }
}

public var kakao_apiKey: String {
         get {
             // 생성한 .plist 파일 경로 불러오기
             guard let filePath = Bundle.main.path(forResource: "Property List", ofType: "plist") else {
                 fatalError("Couldn't find file 'Property List.plist'.")
             }

             // .plist를 딕셔너리로 받아오기
             let plist = NSDictionary(contentsOfFile: filePath)

             // 딕셔너리에서 값 찾기
             guard let value = plist?.object(forKey: "KAKAOMAP_KEY") as? String else {
                 fatalError("Couldn't find key 'KAKAOMAP_KEY' in 'KeyList.plist'.")
             }
             return value
         }
     }
