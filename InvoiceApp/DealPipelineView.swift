import SwiftUI

struct DealPipelineView: View {
    @Binding var deals: [Deal]
    @State private var showingCreateDeal = false
    @State private var selectedDeal: Deal?
    @State private var searchText = ""
    @State private var selectedStage: DealStage?
    
    var body: some View {
        NavigationView {
            VStack {
                // Search and Filter
                VStack(spacing: 12) {
                    SearchBar(text: $searchText, placeholder: "Search deals...")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            FilterChip(
                                title: "All",
                                isSelected: selectedStage == nil,
                                action: { selectedStage = nil }
                            )
                            
                            ForEach(DealStage.allCases, id: \.self) { stage in
                                FilterChip(
                                    title: stage.rawValue,
                                    isSelected: selectedStage == stage,
                                    action: { selectedStage = stage }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 8)
                
                // Deal List
                List {
                    ForEach(filteredDeals) { deal in
                        DealRow(deal: deal)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedDeal = deal
                            }
                    }
                    .onDelete(perform: deleteDeals)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Deal Pipeline")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateDeal = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateDeal) {
                CreateDealView(deals: $deals)
            }
            .sheet(item: $selectedDeal) { deal in
                DealDetailView(deal: deal, deals: $deals)
            }
        }
    }
    
    private var filteredDeals: [Deal] {
        var filtered = deals
        
        if let stage = selectedStage {
            filtered = filtered.filter { $0.stage == stage }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.companyName.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.sector.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.lastUpdateDate > $1.lastUpdateDate }
    }
    
    private func deleteDeals(at offsets: IndexSet) {
        let sortedDeals = filteredDeals
        for index in offsets {
            if let dealIndex = deals.firstIndex(where: { $0.id == sortedDeals[index].id }) {
                deals.remove(at: dealIndex)
            }
        }
    }
}

struct DealRow: View {
    let deal: Deal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(deal.companyName)
                    .font(.headline)
                Spacer()
                StageBadge(stage: deal.stage)
            }
            
            Text(deal.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Label(deal.sector, systemImage: "tag.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if deal.dealSize > 0 {
                    Text(formatCurrency(deal.dealSize))
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
            
            HStack {
                Text("Probability: \(deal.probability)%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(deal.lastUpdateDate, style: .relative)
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

struct StageBadge: View {
    let stage: DealStage
    
    var body: some View {
        Text(stage.rawValue)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(stage.color).opacity(0.2))
            .foregroundColor(Color(stage.color))
            .cornerRadius(8)
    }
}

struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

#Preview {
    DealPipelineView(deals: .constant([
        Deal(companyName: "TechStart", description: "AI-powered SaaS platform", stage: .dueDiligence, sector: "SaaS", dealSize: 500000, probability: 75),
        Deal(companyName: "HealthTech Inc", description: "Digital health solutions", stage: .meeting, sector: "HealthTech", dealSize: 1000000, probability: 50)
    ]))
}


