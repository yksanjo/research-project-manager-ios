import SwiftUI

struct CreateResearchProjectView: View {
    @Binding var projects: [ResearchProject]
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var startDate = Date()
    @State private var endDate: Date? = nil
    @State private var hasEndDate = false
    @State private var selectedEndDate = Date()
    @State private var principalInvestigators: [Researcher] = []
    @State private var collaborators: [Researcher] = []
    @State private var papers: [ResearchPaper] = []
    @State private var fundingSource = ""
    @State private var fundingAmount: Double = 0
    @State private var status: ProjectStatus = .active
    @State private var researchArea = ""
    @State private var tags: [String] = []
    @State private var website = ""
    @State private var notes = ""
    
    @State private var showingAddPI = false
    @State private var showingAddCollaborator = false
    @State private var showingAddPaper = false
    @State private var showingAddTag = false
    @State private var newTag = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Project Details") {
                    TextField("Project Title", text: $title)
                    TextField("Research Area", text: $researchArea)
                    Picker("Status", selection: $status) {
                        ForEach(ProjectStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    Toggle("Has End Date", isOn: $hasEndDate)
                    if hasEndDate {
                        DatePicker("End Date", selection: $selectedEndDate, displayedComponents: .date)
                    }
                }
                
                Section("Description") {
                    TextField("Project description...", text: $description, axis: .vertical)
                        .lineLimit(3...8)
                }
                
                Section("Tags") {
                    if !tags.isEmpty {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
                        }
                        .onDelete(perform: deleteTags)
                    }
                    HStack {
                        TextField("Add tag", text: $newTag)
                        Button("Add") {
                            if !newTag.isEmpty && !tags.contains(newTag) {
                                tags.append(newTag)
                                newTag = ""
                            }
                        }
                        .disabled(newTag.isEmpty)
                    }
                }
                
                Section("Principal Investigators") {
                    ForEach(principalInvestigators) { pi in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(pi.name)
                                .font(.headline)
                            if !pi.title.isEmpty {
                                Text(pi.title)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deletePIs)
                    
                    Button(action: {
                        showingAddPI = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Principal Investigator")
                        }
                    }
                }
                
                Section("Collaborators") {
                    ForEach(collaborators) { collaborator in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(collaborator.name)
                                .font(.headline)
                            if !collaborator.title.isEmpty {
                                Text(collaborator.title)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteCollaborators)
                    
                    Button(action: {
                        showingAddCollaborator = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Collaborator")
                        }
                    }
                }
                
                Section("Research Papers") {
                    ForEach(papers) { paper in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(paper.title)
                                .font(.headline)
                            Text(paper.venue)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: deletePapers)
                    
                    Button(action: {
                        showingAddPaper = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Research Paper")
                        }
                    }
                }
                
                Section("Funding") {
                    TextField("Funding Source", text: $fundingSource)
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("Amount", value: $fundingAmount, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Additional Information") {
                    TextField("Project Website URL", text: $website)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Create Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProject()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddPI) {
                AddResearcherView(researchers: $principalInvestigators)
            }
            .sheet(isPresented: $showingAddCollaborator) {
                AddResearcherView(researchers: $collaborators)
            }
            .sheet(isPresented: $showingAddPaper) {
                AddPaperView(papers: $papers)
            }
        }
    }
    
    private func deleteTags(offsets: IndexSet) {
        tags.remove(atOffsets: offsets)
    }
    
    private func deletePIs(offsets: IndexSet) {
        principalInvestigators.remove(atOffsets: offsets)
    }
    
    private func deleteCollaborators(offsets: IndexSet) {
        collaborators.remove(atOffsets: offsets)
    }
    
    private func deletePapers(offsets: IndexSet) {
        papers.remove(atOffsets: offsets)
    }
    
    private func saveProject() {
        let project = ResearchProject(
            title: title,
            description: description,
            startDate: startDate,
            endDate: hasEndDate ? selectedEndDate : nil,
            principalInvestigators: principalInvestigators,
            collaborators: collaborators,
            papers: papers,
            fundingSource: fundingSource,
            fundingAmount: fundingAmount,
            status: status,
            researchArea: researchArea,
            tags: tags,
            website: website,
            notes: notes
        )
        
        projects.append(project)
        dismiss()
    }
}

struct AddResearcherView: View {
    @Binding var researchers: [Researcher]
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var email = ""
    @State private var title = ""
    @State private var department = ""
    @State private var institution = "Stanford University"
    @State private var bio = ""
    @State private var website = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Researcher Information") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Title", text: $title, prompt: Text("e.g., Professor, PhD Student"))
                    TextField("Department", text: $department)
                    TextField("Institution", text: $institution)
                }
                
                Section("Additional Information") {
                    TextField("Bio", text: $bio, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("Website", text: $website)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Add Researcher")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addResearcher()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func addResearcher() {
        let researcher = Researcher(
            name: name,
            email: email,
            title: title,
            department: department,
            institution: institution,
            bio: bio,
            website: website
        )
        researchers.append(researcher)
        dismiss()
    }
}

struct AddPaperView: View {
    @Binding var papers: [ResearchPaper]
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var authors = ""
    @State private var publicationDate = Date()
    @State private var venue = ""
    @State private var doi = ""
    @State private var abstract = ""
    @State private var status: PaperStatus = .draft
    @State private var url = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Paper Details") {
                    TextField("Title", text: $title)
                    TextField("Authors (comma-separated)", text: $authors)
                    TextField("Venue", text: $venue, prompt: Text("e.g., NeurIPS, ICML, Nature"))
                    DatePicker("Publication Date", selection: $publicationDate, displayedComponents: .date)
                    Picker("Status", selection: $status) {
                        ForEach(PaperStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                }
                
                Section("Additional Information") {
                    TextField("DOI", text: $doi)
                        .autocapitalization(.none)
                    TextField("URL", text: $url)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    TextField("Abstract", text: $abstract, axis: .vertical)
                        .lineLimit(3...8)
                }
            }
            .navigationTitle("Add Paper")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addPaper()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func addPaper() {
        let authorsList = authors.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        
        let paper = ResearchPaper(
            title: title,
            authors: authorsList,
            publicationDate: publicationDate,
            venue: venue,
            doi: doi,
            abstract: abstract,
            status: status,
            url: url
        )
        papers.append(paper)
        dismiss()
    }
}

#Preview {
    CreateResearchProjectView(projects: .constant([]))
}

