import Foundation

struct Client: Identifiable, Codable {
    let id = UUID()
    var name: String
    var email: String
    var phone: String
    var address: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    
    var fullAddress: String {
        "\(address), \(city), \(state) \(zipCode), \(country)"
    }
}
