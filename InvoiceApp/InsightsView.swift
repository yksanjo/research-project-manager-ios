import SwiftUI

struct InsightsView: View {
    @Binding var deals: [Deal]
    @Binding var portfolio: [PortfolioCompany]
    @Binding var theses: [InvestmentThesis]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Kaizen Insights")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Learn and improve from your investments")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Portfolio Performance
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Portfolio Performance")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        PerformanceCard(
                            title: "Total Portfolio Value",
                            value: formatCurrency(totalPortfolioValue),
                            subtitle: "\(portfolio.count) companies"
                        )
                        .padding(.horizontal)
                        
                        PerformanceCard(
                            title: "Average Multiple",
                            value: String(format: "%.1fx", averageMultiple),
                            subtitle: "Across all investments"
                        )
                        .padding(.horizontal)
                        
                        PerformanceCard(
                            title: "Best Performer",
                            value: bestPerformer?.companyName ?? "N/A",
                            subtitle: bestPerformer != nil ? String(format: "%.1fx", bestPerformer!.multiple) : ""
                        )
                        .padding(.horizontal)
                    }
                    
                    // Sector Analysis
                    if !sectorBreakdown.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sector Breakdown")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(Array(sectorBreakdown.keys.sorted()), id: \.self) { sector in
                                if let data = sectorBreakdown[sector] {
                                    SectorCard(
                                        sector: sector,
                                        count: data.count,
                                        totalInvested: data.totalInvested,
                                        avgMultiple: data.avgMultiple
                                    )
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    
                    // Deal Flow Analysis
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Deal Flow Analysis")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            MetricCard(
                                title: "Deals Reviewed",
                                value: "\(deals.count)",
                                subtitle: "Total",
                                color: .blue
                            )
                            
                            MetricCard(
                                title: "Invested",
                                value: "\(investedCount)",
                                subtitle: "\(String(format: "%.0f%%", investedPercentage))%",
                                color: .green
                            )
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            MetricCard(
                                title: "Passed",
                                value: "\(passedCount)",
                                subtitle: "\(String(format: "%.0f%%", passedPercentage))%",
                                color: .red
                            )
                            
                            MetricCard(
                                title: "In Pipeline",
                                value: "\(pipelineCount)",
                                subtitle: "Active",
                                color: .orange
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Investment Theses
                    if !theses.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Investment Theses")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(activeTheses) { thesis in
                                ThesisInsightCard(thesis: thesis)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Learnings
                    if !allLearnings.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Key Learnings")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(allLearnings.prefix(5)) { learning in
                                LearningCard(learning: learning)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Insights")
        }
    }
    
    // Computed properties
    private var totalPortfolioValue: Double {
        portfolio.compactMap { company -> Double? in
            guard let currentVal = company.currentValuation else { return nil }
            return currentVal * company.ownershipPercentage / 100
        }.reduce(0, +)
    }
    
    private var averageMultiple: Double {
        let multiples = portfolio.compactMap { $0.multiple }
        guard !multiples.isEmpty else { return 1.0 }
        return multiples.reduce(0, +) / Double(multiples.count)
    }
    
    private var bestPerformer: PortfolioCompany? {
        portfolio.max(by: { ($0.multiple) < ($1.multiple) })
    }
    
    private var sectorBreakdown: [String: (count: Int, totalInvested: Double, avgMultiple: Double)] {
        var breakdown: [String: (count: Int, totalInvested: Double, multiples: [Double])] = [:]
        
        for company in portfolio {
            let sector = company.sector.isEmpty ? "Other" : company.sector
            if breakdown[sector] == nil {
                breakdown[sector] = (0, 0, [])
            }
            breakdown[sector]?.count += 1
            breakdown[sector]?.totalInvested += company.investmentAmount
            breakdown[sector]?.multiples.append(company.multiple)
        }
        
        return breakdown.mapValues { data in
            let avgMultiple = data.multiples.isEmpty ? 1.0 : data.multiples.reduce(0, +) / Double(data.multiples.count)
            return (count: data.count, totalInvested: data.totalInvested, avgMultiple: avgMultiple)
        }
    }
    
    private var investedCount: Int {
        deals.filter { $0.stage == .invested }.count
    }
    
    private var passedCount: Int {
        deals.filter { $0.stage == .passed }.count
    }
    
    private var pipelineCount: Int {
        deals.filter { $0.stage != .passed && $0.stage != .invested }.count
    }
    
    private var investedPercentage: Double {
        guard !deals.isEmpty else { return 0 }
        return Double(investedCount) / Double(deals.count) * 100
    }
    
    private var passedPercentage: Double {
        guard !deals.isEmpty else { return 0 }
        return Double(passedCount) / Double(deals.count) * 100
    }
    
    private var activeTheses: [InvestmentThesis] {
        theses.filter { $0.status == .active || $0.status == .evolving }
    }
    
    private var allLearnings: [Learning] {
        theses.flatMap { $0.learnings }.sorted { $0.date > $1.date }
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

struct PerformanceCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
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

struct SectorCard: View {
    let sector: String
    let count: Int
    let totalInvested: Double
    let avgMultiple: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(sector)
                    .font(.headline)
                Text("\(count) companies")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.1fx", avgMultiple))
                    .font(.headline)
                    .foregroundColor(avgMultiple > 1.0 ? .green : .secondary)
                Text(formatCurrency(totalInvested))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
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

struct ThesisInsightCard: View {
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
                Text("\(thesis.thesisPoints.count) points")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(thesis.learnings.count) learnings")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct LearningCard: View {
    let learning: Learning
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    InsightsView(
        deals: .constant([]),
        portfolio: .constant([]),
        theses: .constant([])
    )
}


