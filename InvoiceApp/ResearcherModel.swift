import Foundation

struct Researcher: Identifiable, Codable {
    let id = UUID()
    var name: String
    var email: String
    var title: String // e.g., "Professor", "PhD Student", "Research Scientist"
    var department: String
    var institution: String
    var bio: String
    var website: String
    
    init(name: String = "", email: String = "", title: String = "", department: String = "", institution: String = "", bio: String = "", website: String = "") {
        self.name = name
        self.email = email
        self.title = title
        self.department = department
        self.institution = institution
        self.bio = bio
        self.website = website
    }
}

