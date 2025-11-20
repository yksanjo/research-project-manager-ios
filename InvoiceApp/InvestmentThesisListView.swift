import SwiftUI

struct InvestmentThesisListView: View {
    @Binding var theses: [InvestmentThesis]
    @State private var showingCreateThesis = false
    @State private var selectedThesis: InvestmentThesis?
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Search theses...")
                    .padding(.vertical, 8)
                
                List {
                    ForEach(filteredTheses) { thesis in
                        ThesisRow(thesis: thesis)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedThesis = thesis
                            }
                    }
                    .onDelete(perform: deleteTheses)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Investment Theses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateThesis = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateThesis) {
                CreateThesisView(theses: $theses)
            }
            .sheet(item: $selectedThesis) { thesis in
                ThesisDetailView(thesis: thesis, theses: $theses)
            }
        }
    }
    
    private var filteredTheses: [InvestmentThesis] {
        if searchText.isEmpty {
            return theses.sorted { $0.lastUpdatedDate > $1.lastUpdatedDate }
        }
        
        return theses.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText) ||
            $0.sector.localizedCaseInsensitiveContains(searchText)
        }
        .sorted { $0.lastUpdatedDate > $1.lastUpdatedDate }
    }
    
    private func deleteTheses(at offsets: IndexSet) {
        let sortedTheses = filteredTheses
        for index in offsets {
            if let thesisIndex = theses.firstIndex(where: { $0.id == sortedTheses[index].id }) {
                theses.remove(at: thesisIndex)
            }
        }
    }
}

struct ThesisRow: View {
    let thesis: InvestmentThesis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(thesis.title)
                    .font(.headline)
                Spacer()
                Text(thesis.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Text(thesis.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Label(thesis.sector, systemImage: "tag.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(thesis.thesisPoints.count) points")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if !thesis.learnings.isEmpty {
                    Text("• \(thesis.learnings.count) learnings")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    InvestmentThesisListView(theses: .constant([
        InvestmentThesis(
            title: "AI Infrastructure",
            description: "Investing in foundational AI infrastructure companies",
            sector: "AI/ML",
            status: .active
        )
    ]))
}


