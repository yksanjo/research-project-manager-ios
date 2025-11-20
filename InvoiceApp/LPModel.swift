import Foundation

struct LP: Identifiable, Codable {
    let id = UUID()
    var name: String
    var type: LPType
    var contactPerson: String
    var email: String
    var phone: String
    var commitmentAmount: Double
    var committedDate: Date
    var calledAmount: Double // Amount called so far
    var distributedAmount: Double // Amount distributed back
    var status: LPStatus
    var notes: String
    var tags: [String]
    
    var remainingCommitment: Double {
        commitmentAmount - calledAmount
    }
    
    var netContribution: Double {
        calledAmount - distributedAmount
    }
    
    init(name: String = "", type: LPType = .familyOffice, contactPerson: String = "", email: String = "", phone: String = "", commitmentAmount: Double = 0, committedDate: Date = Date(), calledAmount: Double = 0, distributedAmount: Double = 0, status: LPStatus = .active, notes: String = "", tags: [String] = []) {
        self.name = name
        self.type = type
        self.contactPerson = contactPerson
        self.email = email
        self.phone = phone
        self.commitmentAmount = commitmentAmount
        self.committedDate = committedDate
        self.calledAmount = calledAmount
        self.distributedAmount = distributedAmount
        self.status = status
        self.notes = notes
        self.tags = tags
    }
}

enum LPType: String, CaseIterable, Codable {
    case familyOffice = "Family Office"
    case endowment = "Endowment"
    case pensionFund = "Pension Fund"
    case corporate = "Corporate"
    case individual = "Individual"
    case fundOfFunds = "Fund of Funds"
    case sovereignWealth = "Sovereign Wealth Fund"
    case other = "Other"
}

enum LPStatus: String, CaseIterable, Codable {
    case active = "Active"
    case committed = "Committed"
    case inactive = "Inactive"
    case exited = "Exited"
}


