import SwiftUI

struct ContentView: View {
    @State private var deals: [Deal] = []
    @State private var portfolio: [PortfolioCompany] = []
    @State private var theses: [InvestmentThesis] = []
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView(deals: $deals, portfolio: $portfolio, theses: $theses)
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
                .tag(0)
            
            DealPipelineView(deals: $deals)
                .tabItem {
                    Label("Deals", systemImage: "briefcase.fill")
                }
                .tag(1)
            
            PortfolioView(portfolio: $portfolio)
                .tabItem {
                    Label("Portfolio", systemImage: "building.2.fill")
                }
                .tag(2)
            
            InsightsView(deals: $deals, portfolio: $portfolio, theses: $theses)
                .tabItem {
                    Label("Insights", systemImage: "lightbulb.fill")
                }
                .tag(3)
            
            InvestmentThesisListView(theses: $theses)
                .tabItem {
                    Label("Theses", systemImage: "doc.text.fill")
                }
                .tag(4)
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}
