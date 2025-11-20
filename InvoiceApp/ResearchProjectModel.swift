import Foundation

struct ResearchProject: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date?
    var principalInvestigators: [Researcher]
    var collaborators: [Researcher]
    var papers: [ResearchPaper]
    var fundingSource: String
    var fundingAmount: Double
    var status: ProjectStatus
    var researchArea: String // e.g., "AI Ethics", "Machine Learning", "Human-AI Interaction"
    var tags: [String]
    var website: String
    var notes: String
    
    var totalFunding: Double {
        fundingAmount
    }
    
    var publishedPapersCount: Int {
        papers.filter { $0.status == .published }.count
    }
    
    var teamSize: Int {
        principalInvestigators.count + collaborators.count
    }
    
    init(title: String = "", description: String = "", startDate: Date = Date(), endDate: Date? = nil, principalInvestigators: [Researcher] = [], collaborators: [Researcher] = [], papers: [ResearchPaper] = [], fundingSource: String = "", fundingAmount: Double = 0, status: ProjectStatus = .active, researchArea: String = "", tags: [String] = [], website: String = "", notes: String = "") {
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.principalInvestigators = principalInvestigators
        self.collaborators = collaborators
        self.papers = papers
        self.fundingSource = fundingSource
        self.fundingAmount = fundingAmount
        self.status = status
        self.researchArea = researchArea
        self.tags = tags
        self.website = website
        self.notes = notes
    }
}

enum ProjectStatus: String, CaseIterable, Codable {
    case planning = "Planning"
    case active = "Active"
    case onHold = "On Hold"
    case completed = "Completed"
    case archived = "Archived"
    
    var color: String {
        switch self {
        case .planning: return "blue"
        case .active: return "green"
        case .onHold: return "orange"
        case .completed: return "gray"
        case .archived: return "black"
        }
    }
}


