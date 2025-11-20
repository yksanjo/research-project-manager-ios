import SwiftUI

struct ResearchProjectDetailView: View {
    let project: ResearchProject
    @State private var showingShareSheet = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(.systemBackground), Color(.systemGray6).opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                // Header with gradient background
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(project.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            if !project.researchArea.isEmpty {
                                HStack(spacing: 6) {
                                    Image(systemName: "tag.fill")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                    Text(project.researchArea)
                                        .font(.title3)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        Spacer()
                        
                        Text(project.status.rawValue)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color(project.status.color).opacity(0.15))
                            )
                            .foregroundColor(Color(project.status.color))
                    }
                    
                    Divider()
                        .padding(.vertical, 4)
                    
                    HStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 6) {
                            Label("Start Date", systemImage: "calendar")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(project.startDate, style: .date)
                                .font(.body)
                                .fontWeight(.medium)
                        }
                        
                        if let endDate = project.endDate {
                            Spacer()
                            VStack(alignment: .leading, spacing: 6) {
                                Label("End Date", systemImage: "calendar.badge.clock")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(endDate, style: .date)
                                    .font(.body)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                )
                
                // Description
                if !project.description.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "text.alignleft")
                                .foregroundColor(.blue)
                            Text("Description")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        Text(project.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                    )
                }
                
                // Tags
                if !project.tags.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "tag.fill")
                                .foregroundColor(.blue)
                            Text("Tags")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        FlowLayout(spacing: 8) {
                            ForEach(project.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(Color.blue.opacity(0.1))
                                    )
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                    )
                }
                
                // Principal Investigators
                if !project.principalInvestigators.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.blue)
                            Text("Principal Investigators")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        ForEach(project.principalInvestigators) { researcher in
                            ResearcherRow(researcher: researcher)
                            if researcher.id != project.principalInvestigators.last?.id {
                                Divider()
                                    .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                    )
                }
                
                // Collaborators
                if !project.collaborators.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.green)
                            Text("Collaborators")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        ForEach(project.collaborators) { researcher in
                            ResearcherRow(researcher: researcher)
                            if researcher.id != project.collaborators.last?.id {
                                Divider()
                                    .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                    )
                }
                
                // Funding
                if !project.fundingSource.isEmpty || project.fundingAmount > 0 {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "dollarsign.circle.fill")
                                .foregroundColor(.orange)
                            Text("Funding")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        if project.fundingAmount > 0 {
                            Text(formatFunding(project.fundingAmount))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        
                        if !project.fundingSource.isEmpty {
                            Text(project.fundingSource)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                    )
                }
                
                // Research Papers
                if !project.papers.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.purple)
                            Text("Research Papers")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        ForEach(project.papers) { paper in
                            PaperRow(paper: paper)
                            if paper.id != project.papers.last?.id {
                                Divider()
                                    .padding(.vertical, 8)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                    )
                }
                
                // Website
                if !project.website.isEmpty, let url = URL(string: project.website) {
                    Link(destination: url) {
                        HStack {
                            Image(systemName: "link")
                                .foregroundColor(.blue)
                            Text("Project Website")
                                .font(.body)
                                .fontWeight(.medium)
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.blue)
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                    )
                }
                
                // Notes
                if !project.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "note.text")
                                .foregroundColor(.gray)
                            Text("Notes")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        Text(project.notes)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
                    )
                }
                }
                .padding()
            }
        }
        .navigationTitle("Project Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [generateProjectText()])
        }
    }
    
    private func formatFunding(_ amount: Double) -> String {
        if amount >= 1_000_000 {
            return String(format: "$%.1fM", amount / 1_000_000)
        } else if amount >= 1_000 {
            return String(format: "$%.1fK", amount / 1_000)
        } else {
            return String(format: "$%.0f", amount)
        }
    }
    
    private func generateProjectText() -> String {
        var text = "\(project.title)\n"
        if !project.researchArea.isEmpty {
            text += "Research Area: \(project.researchArea)\n"
        }
        text += "Status: \(project.status.rawValue)\n"
        text += "Start Date: \(project.startDate, style: .date)\n"
        if let endDate = project.endDate {
            text += "End Date: \(endDate, style: .date)\n"
        }
        if !project.description.isEmpty {
            text += "\n\(project.description)\n"
        }
        if !project.principalInvestigators.isEmpty {
            text += "\nPrincipal Investigators:\n"
            for pi in project.principalInvestigators {
                text += "- \(pi.name) (\(pi.title))\n"
            }
        }
        if project.fundingAmount > 0 {
            text += "\nFunding: \(project.fundingSource) - $\(String(format: "%.2f", project.fundingAmount))\n"
        }
        return text
    }
}

struct ResearcherRow: View {
    let researcher: Researcher
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(researcher.name)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            if !researcher.title.isEmpty || !researcher.department.isEmpty {
                HStack(spacing: 4) {
                    if !researcher.title.isEmpty {
                        Text(researcher.title)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    if !researcher.title.isEmpty && !researcher.department.isEmpty {
                        Text("•")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    if !researcher.department.isEmpty {
                        Text(researcher.department)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            if !researcher.institution.isEmpty {
                Text(researcher.institution)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !researcher.email.isEmpty {
                Link(destination: URL(string: "mailto:\(researcher.email)")!) {
                    HStack(spacing: 4) {
                        Image(systemName: "envelope.fill")
                            .font(.caption2)
                        Text(researcher.email)
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

struct PaperRow: View {
    let paper: ResearchPaper
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(paper.title)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            if !paper.authors.isEmpty {
                Text(paper.authorsString)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack(spacing: 12) {
                if !paper.venue.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "building.2.fill")
                            .font(.caption2)
                            .foregroundColor(.purple)
                        Text(paper.venue)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(paper.publicationDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(paper.status.rawValue)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color(paper.status.color).opacity(0.15))
                    )
                    .foregroundColor(Color(paper.status.color))
            }
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.width ?? 0,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var frames: [CGRect] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(x: currentX, y: currentY, width: size.width, height: size.height))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationView {
        ResearchProjectDetailView(project: ResearchProject(
            title: "Machine Learning for Climate Prediction",
            description: "Developing advanced ML models to predict climate patterns and extreme weather events using satellite data and historical climate records. This project aims to improve our understanding of climate dynamics and provide more accurate forecasting tools for policymakers and researchers.",
            startDate: Date().addingTimeInterval(-365*24*60*60),
            principalInvestigators: [
                Researcher(name: "Dr. Sarah Chen", email: "sarah.chen@university.edu", title: "Professor", department: "Computer Science", institution: "University of Technology", bio: "Expert in machine learning and climate science"),
                Researcher(name: "Dr. Robert Kim", email: "r.kim@university.edu", title: "Associate Professor", department: "Computer Science", institution: "University of Technology")
            ],
            collaborators: [
                Researcher(name: "Dr. Michael Park", email: "m.park@university.edu", title: "Research Scientist", department: "Environmental Science", institution: "University of Technology"),
                Researcher(name: "Dr. Lisa Wang", email: "l.wang@university.edu", title: "Postdoctoral Researcher", department: "Computer Science", institution: "University of Technology")
            ],
            papers: [
                ResearchPaper(title: "Deep Learning Approaches to Climate Modeling", authors: ["Sarah Chen", "Michael Park", "Robert Kim"], publicationDate: Date().addingTimeInterval(-180*24*60*60), venue: "Nature Climate Change", doi: "10.1038/s41558-023-01789-2", abstract: "We present a novel deep learning framework...", status: .published, url: "https://example.com/paper1"),
                ResearchPaper(title: "Satellite Data Integration for Weather Forecasting", authors: ["Sarah Chen", "Lisa Wang"], publicationDate: Date().addingTimeInterval(-90*24*60*60), venue: "ICML", status: .accepted)
            ],
            fundingSource: "National Science Foundation",
            fundingAmount: 2500000,
            status: .active,
            researchArea: "Machine Learning",
            tags: ["Climate Science", "Deep Learning", "Environmental AI", "Satellite Data", "Weather Prediction"],
            website: "https://example.com/climate-ml",
            notes: "Collaboration with NOAA and NASA. Expected to publish 3-4 papers in the next year."
        ))
    }
}

