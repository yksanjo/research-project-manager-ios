import Foundation

struct PortfolioCompany: Identifiable, Codable {
    let id = UUID()
    var companyName: String
    var description: String
    var sector: String
    var investmentDate: Date
    var investmentAmount: Double
    var valuationAtInvestment: Double // Entry valuation
    var currentValuation: Double? // Latest valuation (if known)
    var ownershipPercentage: Double // Our ownership %
    var stageAtInvestment: String // e.g., "Seed", "Series A"
    var currentStage: String
    var founders: [Founder]
    var boardSeat: Bool
    var boardMember: String // Our board member name
    var keyMetrics: [KeyMetric]
    var milestones: [Milestone]
    var lastUpdateDate: Date
    var notes: String
    var tags: [String]
    var website: String
    
    var multiple: Double {
        guard let currentVal = currentValuation, valuationAtInvestment > 0 else { return 1.0 }
        return currentVal / valuationAtInvestment
    }
    
    var unrealizedGain: Double {
        guard let currentVal = currentValuation else { return 0 }
        let currentValue = (currentVal * ownershipPercentage / 100)
        return currentValue - investmentAmount
    }
    
    var irr: Double? {
        // Simplified IRR calculation (would need more data for accurate calculation)
        let years = Calendar.current.dateComponents([.year], from: investmentDate, to: Date()).year ?? 1
        guard years > 0, multiple > 0 else { return nil }
        return pow(multiple, 1.0 / Double(years)) - 1.0
    }
    
    init(companyName: String = "", description: String = "", sector: String = "", investmentDate: Date = Date(), investmentAmount: Double = 0, valuationAtInvestment: Double = 0, currentValuation: Double? = nil, ownershipPercentage: Double = 0, stageAtInvestment: String = "", currentStage: String = "", founders: [Founder] = [], boardSeat: Bool = false, boardMember: String = "", keyMetrics: [KeyMetric] = [], milestones: [Milestone] = [], lastUpdateDate: Date = Date(), notes: String = "", tags: [String] = [], website: String = "") {
        self.companyName = companyName
        self.description = description
        self.sector = sector
        self.investmentDate = investmentDate
        self.investmentAmount = investmentAmount
        self.valuationAtInvestment = valuationAtInvestment
        self.currentValuation = currentValuation
        self.ownershipPercentage = ownershipPercentage
        self.stageAtInvestment = stageAtInvestment
        self.currentStage = currentStage
        self.founders = founders
        self.boardSeat = boardSeat
        self.boardMember = boardMember
        self.keyMetrics = keyMetrics
        self.milestones = milestones
        self.lastUpdateDate = lastUpdateDate
        self.notes = notes
        self.tags = tags
        self.website = website
    }
}

struct KeyMetric: Identifiable, Codable {
    let id = UUID()
    var name: String // e.g., "MRR", "ARR", "Users", "Revenue"
    var value: Double
    var date: Date
    var unit: String // e.g., "$", "users", "%"
    
    init(name: String = "", value: Double = 0, date: Date = Date(), unit: String = "") {
        self.name = name
        self.value = value
        self.date = date
        self.unit = unit
    }
}

struct Milestone: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var date: Date
    var category: MilestoneCategory
    
    init(title: String = "", description: String = "", date: Date = Date(), category: MilestoneCategory = .other) {
        self.title = title
        self.description = description
        self.date = date
        self.category = category
    }
}

enum MilestoneCategory: String, CaseIterable, Codable {
    case funding = "Funding"
    case product = "Product Launch"
    case partnership = "Partnership"
    case team = "Team"
    case revenue = "Revenue"
    case exit = "Exit"
    case other = "Other"
}


