import SwiftUI

struct PortfolioView: View {
    @Binding var portfolio: [PortfolioCompany]
    @State private var showingCreateCompany = false
    @State private var selectedCompany: PortfolioCompany?
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Search portfolio...")
                    .padding(.vertical, 8)
                
                List {
                    ForEach(filteredPortfolio) { company in
                        PortfolioRow(company: company)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedCompany = company
                            }
                    }
                    .onDelete(perform: deleteCompanies)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateCompany = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateCompany) {
                CreatePortfolioCompanyView(portfolio: $portfolio)
            }
            .sheet(item: $selectedCompany) { company in
                PortfolioCompanyDetailView(company: company, portfolio: $portfolio)
            }
        }
    }
    
    private var filteredPortfolio: [PortfolioCompany] {
        if searchText.isEmpty {
            return portfolio.sorted { $0.investmentDate > $1.investmentDate }
        }
        
        return portfolio.filter {
            $0.companyName.localizedCaseInsensitiveContains(searchText) ||
            $0.sector.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
        .sorted { $0.investmentDate > $1.investmentDate }
    }
    
    private func deleteCompanies(at offsets: IndexSet) {
        let sortedPortfolio = filteredPortfolio
        for index in offsets {
            if let companyIndex = portfolio.firstIndex(where: { $0.id == sortedPortfolio[index].id }) {
                portfolio.remove(at: companyIndex)
            }
        }
    }
}

struct PortfolioRow: View {
    let company: PortfolioCompany
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(company.companyName)
                    .font(.headline)
                Spacer()
                if let multiple = company.multiple, multiple > 1.0 {
                    Text(String(format: "%.1fx", multiple))
                        .font(.headline)
                        .foregroundColor(.green)
                }
            }
            
            Text(company.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Label(company.sector, systemImage: "tag.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(formatCurrency(company.investmentAmount))
                    .font(.caption)
                    .fontWeight(.medium)
            }
            
            HStack {
                Text(company.currentStage)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                
                Spacer()
                
                Text(company.investmentDate, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
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
    PortfolioView(portfolio: .constant([
        PortfolioCompany(
            companyName: "TechStart",
            description: "AI-powered SaaS platform",
            sector: "SaaS",
            investmentAmount: 500000,
            valuationAtInvestment: 5000000,
            currentValuation: 15000000,
            ownershipPercentage: 10,
            currentStage: "Series A"
        )
    ]))
}


