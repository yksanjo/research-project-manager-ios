import Foundation

struct Meeting: Identifiable, Codable {
    let id = UUID()
    var title: String
    var type: MeetingType
    var date: Date
    var duration: Int // minutes
    var attendees: [Attendee]
    var dealId: UUID? // Related deal
    var portfolioCompanyId: UUID? // Related portfolio company
    var notes: String
    var actionItems: [ActionItem]
    var followUpDate: Date?
    var tags: [String]
    
    init(title: String = "", type: MeetingType = .founder, date: Date = Date(), duration: Int = 60, attendees: [Attendee] = [], dealId: UUID? = nil, portfolioCompanyId: UUID? = nil, notes: String = "", actionItems: [ActionItem] = [], followUpDate: Date? = nil, tags: [String] = []) {
        self.title = title
        self.type = type
        self.date = date
        self.duration = duration
        self.attendees = attendees
        self.dealId = dealId
        self.portfolioCompanyId = portfolioCompanyId
        self.notes = notes
        self.actionItems = actionItems
        self.followUpDate = followUpDate
        self.tags = tags
    }
}

enum MeetingType: String, CaseIterable, Codable {
    case founder = "Founder Meeting"
    case dueDiligence = "Due Diligence"
    case portfolio = "Portfolio Update"
    case lp = "LP Meeting"
    case internal = "Internal"
    case networking = "Networking"
    case other = "Other"
}

struct Attendee: Identifiable, Codable {
    let id = UUID()
    var name: String
    var role: String
    var email: String
    
    init(name: String = "", role: String = "", email: String = "") {
        self.name = name
        self.role = role
        self.email = email
    }
}

struct ActionItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var assignedTo: String
    var dueDate: Date?
    var completed: Bool
    var notes: String
    
    init(title: String = "", assignedTo: String = "", dueDate: Date? = nil, completed: Bool = false, notes: String = "") {
        self.title = title
        self.assignedTo = assignedTo
        self.dueDate = dueDate
        self.completed = completed
        self.notes = notes
    }
}


