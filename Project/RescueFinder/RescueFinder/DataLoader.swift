import Foundation


public class DataLoader {
    
    @Published var rescue_data = [Rescue]()
    
    init() {
        load()
    }
    
    func load() {
        
        if let filepath = Bundle.main.url(forResource: "rescue_data", withExtension: "json") {
        
            do {
            
                let data = try Data(contentsOf: filepath)
                let jsondecoder = JSONDecoder()
                let datafromjson = try jsondecoder.decode([Rescue].self, from: data)
                
                self.rescue_data = datafromjson
                } catch {
                    
                    print(error)
            
                }
        }
    }
}
