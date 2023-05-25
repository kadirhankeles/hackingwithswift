
import UIKit

class CustomPhoto: NSObject, Codable {
    var image: String
    var title: String
    
    init(image: String, title: String) {
        self.image = image
        self.title = title
    }
}
