import Foundation

struct Invoice: Identifiable, Codable {
    let id = UUID()
    var invoiceNumber: String
    var issueDate: Date
    var dueDate: Date
    var client: Client
    var items: [InvoiceItem]
    var notes: String
    var status: InvoiceStatus
    
    var subtotal: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }
    
    var totalTax: Double {
        items.reduce(0) { $0 + $1.taxAmount }
    }
    
    var total: Double {
        subtotal + totalTax
    }
    
    init(invoiceNumber: String = "", issueDate: Date = Date(), dueDate: Date = Date().addingTimeInterval(30*24*60*60), client: Client = Client(name: "", email: "", phone: "", address: "", city: "", state: "", zipCode: "", country: ""), items: [InvoiceItem] = [], notes: String = "", status: InvoiceStatus = .draft) {
        self.invoiceNumber = invoiceNumber
        self.issueDate = issueDate
        self.dueDate = dueDate
        self.client = client
        self.items = items
        self.notes = notes
        self.status = status
    }
}

enum InvoiceStatus: String, CaseIterable, Codable {
    case draft = "Draft"
    case sent = "Sent"
    case paid = "Paid"
    case overdue = "Overdue"
    case cancelled = "Cancelled"
    
    var color: String {
        switch self {
        case .draft: return "gray"
        case .sent: return "blue"
        case .paid: return "green"
        case .overdue: return "red"
        case .cancelled: return "black"
        }
    }
}
