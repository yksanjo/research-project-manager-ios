import Foundation

struct InvoiceItem: Identifiable, Codable {
    let id = UUID()
    var description: String
    var quantity: Double
    var unitPrice: Double
    var taxRate: Double
    
    var subtotal: Double {
        quantity * unitPrice
    }
    
    var taxAmount: Double {
        subtotal * (taxRate / 100)
    }
    
    var total: Double {
        subtotal + taxAmount
    }
}
