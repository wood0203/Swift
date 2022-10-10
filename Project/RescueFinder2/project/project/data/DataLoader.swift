import Foundation


public class DataLoader {
    
    @Published var rescue_data = [Rescue]()
    @Published var hospital_data = [Hospital]()
    
    init() {
        load(filename: "rescue_data")
        load(filename: "hospital_data")
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
