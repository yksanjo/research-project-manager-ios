import SwiftUI

struct DashboardView: View {
    @Binding var deals: [Deal]
    @Binding var portfolio: [PortfolioCompany]
    @Binding var theses: [InvestmentThesis]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                Text("VC Kaizen")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Text("Continuous Improvement in Investing")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                // Key Metrics
                VStack(alignment: .leading, spacing: 12) {
                    Text("Key Metrics")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    HStack(spacing: 12) {
                        MetricCard(
                            title: "Active Deals",
                            value: "\(activeDealsCount)",
                            subtitle: "\(dealsInPipeline) in pipeline",
                            color: .blue
                        )
                        
                        MetricCard(
                            title: "Portfolio",
                            value: "\(portfolio.count)",
                            subtitle: "\(activePortfolioCount) active",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 12) {
                        MetricCard(
                            title: "Total Invested",
                            value: formatCurrency(totalInvested),
                            subtitle: "Across portfolio",
                            color: .purple
                        )
                        
                        MetricCard(
                            title: "Avg Multiple",
                            value: String(format: "%.1fx", averageMultiple),
                            subtitle: "Portfolio performance",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Recent Activity
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Activity")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if let recentDeal = recentDeals.first {
                        ActivityCard(
                            icon: "briefcase.fill",
                            title: "Latest Deal: \(recentDeal.companyName)",
                            subtitle: recentDeal.stage.rawValue,
                            date: recentDeal.lastUpdateDate
                        )
                        .padding(.horizontal)
                    }
                    
                    if let recentPortfolio = recentPortfolio.first {
                        ActivityCard(
                            icon: "building.2.fill",
                            title: "Portfolio Update: \(recentPortfolio.companyName)",
                            subtitle: recentPortfolio.currentStage,
                            date: recentPortfolio.lastUpdateDate
                        )
                        .padding(.horizontal)
                    }
                }
                
                // Investment Theses
                VStack(alignment: .leading, spacing: 12) {
                    Text("Active Investment Theses")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(activeTheses.prefix(3)) { thesis in
                        ThesisCard(thesis: thesis)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    // Computed properties
    private var activeDealsCount: Int {
        deals.filter { $0.stage != .passed && $0.stage != .invested }.count
    }
    
    private var dealsInPipeline: Int {
        deals.filter { $0.stage != .passed && $0.stage != .invested && $0.stage != .sourcing }.count
    }
    
    private var activePortfolioCount: Int {
        portfolio.filter { $0.currentStage != "Exited" && $0.currentStage != "Acquired" }.count
    }
    
    private var totalInvested: Double {
        portfolio.reduce(0) { $0 + $1.investmentAmount }
    }
    
    private var averageMultiple: Double {
        let multiples = portfolio.compactMap { $0.multiple }
        guard !multiples.isEmpty else { return 1.0 }
        return multiples.reduce(0, +) / Double(multiples.count)
    }
    
    private var recentDeals: [Deal] {
        deals.sorted { $0.lastUpdateDate > $1.lastUpdateDate }
    }
    
    private var recentPortfolio: [PortfolioCompany] {
        portfolio.sorted { $0.lastUpdateDate > $1.lastUpdateDate }
    }
    
    private var activeTheses: [InvestmentThesis] {
        theses.filter { $0.status == .active || $0.status == .evolving }
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

struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ActivityCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let date: Date
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title2)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(date, style: .relative)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ThesisCard: View {
    let thesis: InvestmentThesis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(thesis.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(thesis.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Text(thesis.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            if !thesis.learnings.isEmpty {
                Text("\(thesis.learnings.count) learnings")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    DashboardView(
        deals: .constant([]),
        portfolio: .constant([]),
        theses: .constant([])
    )
}


