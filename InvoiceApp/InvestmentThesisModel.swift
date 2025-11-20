import Foundation

struct InvestmentThesis: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var sector: String
    var thesisPoints: [ThesisPoint]
    var createdDate: Date
    var lastUpdatedDate: Date
    var status: ThesisStatus
    var relatedDeals: [UUID] // Deal IDs
    var relatedPortfolio: [UUID] // Portfolio company IDs
    var learnings: [Learning]
    var tags: [String]
    
    init(title: String = "", description: String = "", sector: String = "", thesisPoints: [ThesisPoint] = [], createdDate: Date = Date(), lastUpdatedDate: Date = Date(), status: ThesisStatus = .active, relatedDeals: [UUID] = [], relatedPortfolio: [UUID] = [], learnings: [Learning] = [], tags: [String] = []) {
        self.title = title
        self.description = description
        self.sector = sector
        self.thesisPoints = thesisPoints
        self.createdDate = createdDate
        self.lastUpdatedDate = lastUpdatedDate
        self.status = status
        self.relatedDeals = relatedDeals
        self.relatedPortfolio = relatedPortfolio
        self.learnings = learnings
        self.tags = tags
    }
}

struct ThesisPoint: Identifiable, Codable {
    let id = UUID()
    var point: String
    var validated: Bool // Whether this point has been validated through investments
    var validationNotes: String
    
    init(point: String = "", validated: Bool = false, validationNotes: String = "") {
        self.point = point
        self.validated = validated
        self.validationNotes = validationNotes
    }
}

struct Learning: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var date: Date
    var category: LearningCategory
    var impact: LearningImpact
    
    init(title: String = "", description: String = "", date: Date = Date(), category: LearningCategory = .pattern, impact: LearningImpact = .medium) {
        self.title = title
        self.description = description
        self.date = date
        self.category = category
        self.impact = impact
    }
}

enum ThesisStatus: String, CaseIterable, Codable {
    case active = "Active"
    case validated = "Validated"
    case evolving = "Evolving"
    case retired = "Retired"
}

enum LearningCategory: String, CaseIterable, Codable {
    case pattern = "Pattern Recognition"
    case mistake = "Mistake"
    case success = "Success Factor"
    case market = "Market Insight"
    case team = "Team Dynamics"
    case other = "Other"
}

enum LearningImpact: String, CaseIterable, Codable {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
}


