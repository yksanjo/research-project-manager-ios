import Foundation

struct ResearchPaper: Identifiable, Codable {
    let id = UUID()
    var title: String
    var authors: [String]
    var publicationDate: Date
    var venue: String // e.g., "NeurIPS", "ICML", "Nature"
    var doi: String
    var abstract: String
    var status: PaperStatus
    var url: String
    
    init(title: String = "", authors: [String] = [], publicationDate: Date = Date(), venue: String = "", doi: String = "", abstract: String = "", status: PaperStatus = .draft, url: String = "") {
        self.title = title
        self.authors = authors
        self.publicationDate = publicationDate
        self.venue = venue
        self.doi = doi
        self.abstract = abstract
        self.status = status
        self.url = url
    }
    
    var authorsString: String {
        authors.joined(separator: ", ")
    }
}

enum PaperStatus: String, CaseIterable, Codable {
    case draft = "Draft"
    case submitted = "Submitted"
    case underReview = "Under Review"
    case accepted = "Accepted"
    case published = "Published"
    case rejected = "Rejected"
    
    var color: String {
        switch self {
        case .draft: return "gray"
        case .submitted: return "blue"
        case .underReview: return "orange"
        case .accepted: return "green"
        case .published: return "green"
        case .rejected: return "red"
        }
    }
}


