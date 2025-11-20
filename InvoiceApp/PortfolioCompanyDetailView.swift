import SwiftUI

struct PortfolioCompanyDetailView: View {
    let company: PortfolioCompany
    @Binding var portfolio: [PortfolioCompany]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(company.companyName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        if !company.website.isEmpty {
                            Link(company.website, destination: URL(string: company.website) ?? URL(string: "https://example.com")!)
                                .font(.subheadline)
                        }
                    }
                    .padding()
                    
                    // Performance Metrics
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Performance")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            InfoCard(
                                title: "Multiple",
                                value: String(format: "%.1fx", company.multiple)
                            )
                            InfoCard(
                                title: "Unrealized Gain",
                                value: formatCurrency(company.unrealizedGain)
                            )
                        }
                        .padding(.horizontal)
                        
                        if let irr = company.irr {
                            InfoCard(
                                title: "IRR",
                                value: String(format: "%.1f%%", irr * 100)
                            )
                            .padding(.horizontal)
                        }
                    }
                    
                    // Investment Details
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Investment Details")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            InfoCard(
                                title: "Invested",
                                value: formatCurrency(company.investmentAmount)
                            )
                            InfoCard(
                                title: "Entry Valuation",
                                value: formatCurrency(company.valuationAtInvestment)
                            )
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 12) {
                            InfoCard(
                                title: "Ownership",
                                value: String(format: "%.1f%%", company.ownershipPercentage)
                            )
                            if let currentVal = company.currentValuation {
                                InfoCard(
                                    title: "Current Valuation",
                                    value: formatCurrency(currentVal)
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Company Info
                    if !company.description.isEmpty {
                        SectionView(title: "Description") {
                            Text(company.description)
                                .font(.body)
                        }
                    }
                    
                    // Stage
                    SectionView(title: "Stage") {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("At Investment:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(company.stageAtInvestment)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            HStack {
                                Text("Current:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(company.currentStage)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    
                    // Board
                    if company.boardSeat {
                        SectionView(title: "Board") {
                            Text("Board Member: \(company.boardMember)")
                                .font(.body)
                        }
                    }
                    
                    // Notes
                    if !company.notes.isEmpty {
                        SectionView(title: "Notes") {
                            Text(company.notes)
                                .font(.body)
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

#Preview {
    PortfolioCompanyDetailView(
        company: PortfolioCompany(
            companyName: "TechStart",
            description: "AI-powered SaaS platform",
            sector: "SaaS",
            investmentAmount: 500000,
            valuationAtInvestment: 5000000,
            currentValuation: 15000000,
            ownershipPercentage: 10,
            stageAtInvestment: "Seed",
            currentStage: "Series A",
            boardSeat: true,
            boardMember: "John Doe"
        ),
        portfolio: .constant([])
    )
}


