import SwiftUI

struct ThesisDetailView: View {
    let thesis: InvestmentThesis
    @Binding var theses: [InvestmentThesis]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(thesis.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text(thesis.status.rawValue)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                            
                            if !thesis.sector.isEmpty {
                                Label(thesis.sector, systemImage: "tag.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    
                    // Description
                    if !thesis.description.isEmpty {
                        SectionView(title: "Description") {
                            Text(thesis.description)
                                .font(.body)
                        }
                    }
                    
                    // Thesis Points
                    if !thesis.thesisPoints.isEmpty {
                        SectionView(title: "Thesis Points") {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(thesis.thesisPoints) { point in
                                    HStack(alignment: .top, spacing: 12) {
                                        if point.validated {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        } else {
                                            Image(systemName: "circle")
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(point.point)
                                                .font(.body)
                                            
                                            if !point.validationNotes.isEmpty {
                                                Text(point.validationNotes)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                    .italic()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Learnings
                    if !thesis.learnings.isEmpty {
                        SectionView(title: "Learnings") {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(thesis.learnings) { learning in
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(learning.title)
                                                .font(.headline)
                                            Spacer()
                                            Text(learning.category.rawValue)
                                                .font(.caption)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.purple.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                        
                                        Text(learning.description)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                        Text(learning.date, style: .date)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 4)
                                    
                                    if learning.id != thesis.learnings.last?.id {
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
                    
                    // Metadata
                    SectionView(title: "Metadata") {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Created:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(thesis.createdDate, style: .date)
                                    .font(.subheadline)
                            }
                            
                            HStack {
                                Text("Last Updated:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(thesis.lastUpdatedDate, style: .date)
                                    .font(.subheadline)
                            }
                            
                            if !thesis.relatedPortfolio.isEmpty {
                                Text("Related Portfolio Companies: \(thesis.relatedPortfolio.count)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ThesisDetailView(
        thesis: InvestmentThesis(
            title: "AI Infrastructure",
            description: "Investing in foundational AI infrastructure companies",
            sector: "AI/ML",
            thesisPoints: [
                ThesisPoint(point: "Strong technical team with domain expertise"),
                ThesisPoint(point: "Large addressable market", validated: true)
            ],
            status: .active
        ),
        theses: .constant([])
    )
}


