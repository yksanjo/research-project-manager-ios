import SwiftUI

struct DealDetailView: View {
    let deal: Deal
    @Binding var deals: [Deal]
    @Environment(\.dismiss) var dismiss
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(deal.companyName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        StageBadge(stage: deal.stage)
                        
                        if !deal.website.isEmpty {
                            Link(deal.website, destination: URL(string: deal.website) ?? URL(string: "https://example.com")!)
                                .font(.subheadline)
                        }
                    }
                    .padding()
                    
                    // Key Metrics
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Deal Metrics")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            InfoCard(title: "Deal Size", value: formatCurrency(deal.dealSize))
                            InfoCard(title: "Valuation", value: formatCurrency(deal.valuation))
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            InfoCard(title: "Probability", value: "\(deal.probability)%")
                            InfoCard(title: "Sector", value: deal.sector)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Description
                    if !deal.description.isEmpty {
                        SectionView(title: "Description") {
                            Text(deal.description)
                                .font(.body)
                        }
                    }
                    
                    // Investment Thesis
                    if !deal.investmentThesis.isEmpty {
                        SectionView(title: "Investment Thesis") {
                            Text(deal.investmentThesis)
                                .font(.body)
                        }
                    }
                    
                    // Concerns
                    if !deal.concerns.isEmpty {
                        SectionView(title: "Concerns") {
                            Text(deal.concerns)
                                .font(.body)
                                .foregroundColor(.orange)
                        }
                    }
                    
                    // Notes
                    if !deal.notes.isEmpty {
                        SectionView(title: "Notes") {
                            Text(deal.notes)
                                .font(.body)
                        }
                    }
                    
                    // Timeline
                    SectionView(title: "Timeline") {
                        VStack(alignment: .leading, spacing: 8) {
                            TimelineItem(label: "First Contact", date: deal.firstContactDate)
                            TimelineItem(label: "Last Update", date: deal.lastUpdateDate)
                            if let nextAction = deal.nextActionDate {
                                TimelineItem(label: "Next Action", date: nextAction)
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
    
    private func formatCurrency(_ amount: Double) -> String {
        if amount >= 1_000_000 {
            return String(format: "$%.1fM", amount / 1_000_000)
        } else if amount >= 1_000 {
            return String(format: "$%.1fK", amount / 1_000)
        } else {
            return String(format: "$%.0f", amount)
        }
    }
}

struct SectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            
            content
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct TimelineItem: View {
    let label: String
    let date: Date
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(date, style: .date)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    DealDetailView(
        deal: Deal(
            companyName: "TechStart",
            description: "AI-powered SaaS platform",
            stage: .dueDiligence,
            sector: "SaaS",
            dealSize: 500000,
            valuation: 5000000,
            probability: 75,
            investmentThesis: "Strong team with domain expertise",
            concerns: "Market competition",
            notes: "Follow up next week"
        ),
        deals: .constant([])
    )
}


