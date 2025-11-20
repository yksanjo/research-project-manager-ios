import SwiftUI

struct ResearchProjectListView: View {
    @Binding var projects: [ResearchProject]
    @State private var searchText = ""
    @State private var selectedStatus: ProjectStatus? = nil
    @State private var selectedArea: String? = nil
    
    var filteredProjects: [ResearchProject] {
        var filtered = projects
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { project in
                project.title.localizedCaseInsensitiveContains(searchText) ||
                project.description.localizedCaseInsensitiveContains(searchText) ||
                project.researchArea.localizedCaseInsensitiveContains(searchText) ||
                project.principalInvestigators.contains { $0.name.localizedCaseInsensitiveContains(searchText) } ||
                project.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // Filter by status
        if let status = selectedStatus {
            filtered = filtered.filter { $0.status == status }
        }
        
        // Filter by research area
        if let area = selectedArea, !area.isEmpty {
            filtered = filtered.filter { $0.researchArea == area }
        }
        
        return filtered
    }
    
    var uniqueResearchAreas: [String] {
        Array(Set(projects.map { $0.researchArea })).sorted().filter { !$0.isEmpty }
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(.systemBackground), Color(.systemGray6).opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if filteredProjects.isEmpty {
                if projects.isEmpty {
                    VStack(spacing: 24) {
                        Image(systemName: "flask.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        VStack(spacing: 8) {
                            Text("No Research Projects Yet")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Text("Create your first research project to get started")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No projects match your search")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        if selectedStatus != nil || selectedArea != nil {
                            Button("Clear Filters") {
                                selectedStatus = nil
                                selectedArea = nil
                                searchText = ""
                            }
                            .buttonStyle(.bordered)
                            .padding(.top, 8)
                        }
                    }
                    .padding()
                }
            } else {
                List {
                    ForEach(filteredProjects) { project in
                        NavigationLink(destination: ResearchProjectDetailView(project: project)) {
                            ResearchProjectRowView(project: project)
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                        )
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                    .onDelete(perform: deleteProjects)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .searchable(text: $searchText, prompt: "Search projects, areas, or researchers...")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Section("Status") {
                        Button {
                            selectedStatus = nil
                        } label: {
                            HStack {
                                Text("All Statuses")
                                if selectedStatus == nil {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        ForEach(ProjectStatus.allCases, id: \.self) { status in
                            Button {
                                selectedStatus = status
                            } label: {
                                HStack {
                                    Text(status.rawValue)
                                    if selectedStatus == status {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    }
                    
                    if !uniqueResearchAreas.isEmpty {
                        Section("Research Area") {
                            Button {
                                selectedArea = nil
                            } label: {
                                HStack {
                                    Text("All Areas")
                                    if selectedArea == nil {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                            ForEach(uniqueResearchAreas, id: \.self) { area in
                                Button {
                                    selectedArea = area
                                } label: {
                                    HStack {
                                        Text(area)
                                        if selectedArea == area {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: selectedStatus != nil || selectedArea != nil ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                        .foregroundColor(selectedStatus != nil || selectedArea != nil ? .blue : .primary)
                }
            }
        }
    }
    
    private func deleteProjects(offsets: IndexSet) {
        projects.remove(atOffsets: offsets)
    }
}

struct ResearchProjectRowView: View {
    let project: ResearchProject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with title and status
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(project.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    if !project.researchArea.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "tag.fill")
                                .font(.caption2)
                                .foregroundColor(.blue)
                            Text(project.researchArea)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                // Status badge
                Text(project.status.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color(project.status.color).opacity(0.15))
                    )
                    .foregroundColor(Color(project.status.color))
            }
            
            // Description preview
            if !project.description.isEmpty {
                Text(project.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            // Stats row
            HStack(spacing: 16) {
                if !project.principalInvestigators.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        Text("\(project.principalInvestigators.count) PI\(project.principalInvestigators.count > 1 ? "s" : "")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if !project.collaborators.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.caption2)
                            .foregroundColor(.green)
                        Text("\(project.collaborators.count)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if !project.papers.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.text.fill")
                            .font(.caption2)
                            .foregroundColor(.purple)
                        Text("\(project.publishedPapersCount)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if project.fundingAmount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.caption2)
                            .foregroundColor(.orange)
                        Text(formatFunding(project.fundingAmount))
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Tags
            if !project.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(project.tags.prefix(5), id: \.self) { tag in
                            Text(tag)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.blue.opacity(0.1))
                                )
                                .foregroundColor(.blue)
                        }
                        if project.tags.count > 5 {
                            Text("+\(project.tags.count - 5)")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.gray.opacity(0.1))
                                )
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            // Date
            HStack {
                Image(systemName: "calendar")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text("Started \(project.startDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
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
}

#Preview {
    NavigationView {
        ResearchProjectListView(projects: .constant([
            ResearchProject(
                title: "Machine Learning for Climate Prediction",
                description: "Developing advanced ML models to predict climate patterns and extreme weather events using satellite data and historical climate records.",
                startDate: Date().addingTimeInterval(-365*24*60*60),
                principalInvestigators: [
                    Researcher(name: "Dr. Sarah Chen", email: "sarah.chen@university.edu", title: "Professor", department: "Computer Science", institution: "University of Technology")
                ],
                collaborators: [
                    Researcher(name: "Dr. Michael Park", email: "m.park@university.edu", title: "Research Scientist", department: "Environmental Science", institution: "University of Technology")
                ],
                papers: [
                    ResearchPaper(title: "Deep Learning Approaches to Climate Modeling", authors: ["Sarah Chen", "Michael Park"], publicationDate: Date().addingTimeInterval(-180*24*60*60), venue: "Nature Climate Change", status: .published)
                ],
                fundingSource: "National Science Foundation",
                fundingAmount: 2500000,
                status: .active,
                researchArea: "Machine Learning",
                tags: ["Climate Science", "Deep Learning", "Environmental AI"],
                website: "https://example.com/climate-ml"
            ),
            ResearchProject(
                title: "Quantum Computing Algorithms",
                description: "Exploring novel quantum algorithms for optimization problems in computational biology.",
                startDate: Date().addingTimeInterval(-200*24*60*60),
                principalInvestigators: [
                    Researcher(name: "Dr. James Wilson", email: "j.wilson@university.edu", title: "Associate Professor", department: "Physics", institution: "University of Technology")
                ],
                fundingSource: "Department of Energy",
                fundingAmount: 1800000,
                status: .active,
                researchArea: "Quantum Computing",
                tags: ["Quantum Algorithms", "Optimization", "Computational Biology"]
            ),
            ResearchProject(
                title: "Neural Interfaces for Rehabilitation",
                description: "Developing brain-computer interfaces to assist patients with motor disabilities.",
                startDate: Date().addingTimeInterval(-100*24*60*60),
                endDate: Date().addingTimeInterval(200*24*60*60),
                principalInvestigators: [
                    Researcher(name: "Dr. Emily Rodriguez", email: "e.rodriguez@university.edu", title: "Professor", department: "Biomedical Engineering", institution: "University of Technology")
                ],
                fundingAmount: 3200000,
                status: .active,
                researchArea: "Biomedical Engineering",
                tags: ["BCI", "Rehabilitation", "Neuroscience"]
            )
        ]))
    }
}

