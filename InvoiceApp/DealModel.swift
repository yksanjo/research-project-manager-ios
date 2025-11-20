import Foundation

struct Deal: Identifiable, Codable {
    let id = UUID()
    var companyName: String
    var description: String
    var stage: DealStage
    var sector: String // e.g., "SaaS", "FinTech", "HealthTech", "AI/ML"
    var dealSize: Double // Investment amount
    var valuation: Double // Pre-money or post-money valuation
    var leadInvestor: String
    var founders: [Founder]
    var firstContactDate: Date
    var lastUpdateDate: Date
    var nextActionDate: Date?
    var probability: Int // 0-100%
    var investmentThesis: String
    var concerns: String
    var notes: String
    var tags: [String]
    var website: String
    
    init(companyName: String = "", description: String = "", stage: DealStage = .sourcing, sector: String = "", dealSize: Double = 0, valuation: Double = 0, leadInvestor: String = "", founders: [Founder] = [], firstContactDate: Date = Date(), lastUpdateDate: Date = Date(), nextActionDate: Date? = nil, probability: Int = 0, investmentThesis: String = "", concerns: String = "", notes: String = "", tags: [String] = [], website: String = "") {
        self.companyName = companyName
        self.description = description
        self.stage = stage
        self.sector = sector
        self.dealSize = dealSize
        self.valuation = valuation
        self.leadInvestor = leadInvestor
        self.founders = founders
        self.firstContactDate = firstContactDate
        self.lastUpdateDate = lastUpdateDate
        self.nextActionDate = nextActionDate
        self.probability = probability
        self.investmentThesis = investmentThesis
        self.concerns = concerns
        self.notes = notes
        self.tags = tags
        self.website = website
    }
}

enum DealStage: String, CaseIterable, Codable {
    case sourcing = "Sourcing"
    case initialReview = "Initial Review"
    case meeting = "Meeting Scheduled"
    case dueDiligence = "Due Diligence"
    case termSheet = "Term Sheet"
    case closing = "Closing"
    case passed = "Passed"
    case invested = "Invested"
    
    var color: String {
        switch self {
        case .sourcing: return "gray"
        case .initialReview: return "blue"
        case .meeting: return "cyan"
        case .dueDiligence: return "orange"
        case .termSheet: return "purple"
        case .closing: return "pink"
        case .passed: return "red"
        case .invested: return "green"
        }
    }
    
    var order: Int {
        switch self {
        case .sourcing: return 0
        case .initialReview: return 1
        case .meeting: return 2
        case .dueDiligence: return 3
        case .termSheet: return 4
        case .closing: return 5
        case .invested: return 6
        case .passed: return 7
        }
    }
}

struct Founder: Identifiable, Codable {
    let id = UUID()
    var name: String
    var title: String
    var email: String
    var linkedIn: String
    var background: String
    
    init(name: String = "", title: String = "", email: String = "", linkedIn: String = "", background: String = "") {
        self.name = name
        self.title = title
        self.email = email
        self.linkedIn = linkedIn
        self.background = background
    }
}


