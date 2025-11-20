import SwiftUI

struct CreatePortfolioCompanyView: View {
    @Binding var portfolio: [PortfolioCompany]
    @Environment(\.dismiss) var dismiss
    
    @State private var companyName = ""
    @State private var description = ""
    @State private var sector = ""
    @State private var investmentDate = Date()
    @State private var investmentAmount = ""
    @State private var valuationAtInvestment = ""
    @State private var currentValuation = ""
    @State private var ownershipPercentage = ""
    @State private var stageAtInvestment = ""
    @State private var currentStage = ""
    @State private var boardSeat = false
    @State private var boardMember = ""
    @State private var notes = ""
    @State private var website = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Company Information")) {
                    TextField("Company Name", text: $companyName)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("Sector", text: $sector)
                    TextField("Website", text: $website)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("Investment Details")) {
                    DatePicker("Investment Date", selection: $investmentDate, displayedComponents: .date)
                    
                    TextField("Investment Amount", text: $investmentAmount)
                        .keyboardType(.decimalPad)
                    
                    TextField("Valuation at Investment", text: $valuationAtInvestment)
                        .keyboardType(.decimalPad)
                    
                    TextField("Ownership %", text: $ownershipPercentage)
                        .keyboardType(.decimalPad)
                    
                    TextField("Stage at Investment", text: $stageAtInvestment)
                    TextField("Current Stage", text: $currentStage)
                }
                
                Section(header: Text("Current Status")) {
                    TextField("Current Valuation (optional)", text: $currentValuation)
                        .keyboardType(.decimalPad)
                    
                    Toggle("Board Seat", isOn: $boardSeat)
                    
                    if boardSeat {
                        TextField("Board Member", text: $boardMember)
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Portfolio Company")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCompany()
                    }
                    .disabled(companyName.isEmpty)
                }
            }
        }
    }
    
    private func saveCompany() {
        let company = PortfolioCompany(
            companyName: companyName,
            description: description,
            sector: sector,
            investmentDate: investmentDate,
            investmentAmount: Double(investmentAmount) ?? 0,
            valuationAtInvestment: Double(valuationAtInvestment) ?? 0,
            currentValuation: currentValuation.isEmpty ? nil : Double(currentValuation),
            ownershipPercentage: Double(ownershipPercentage) ?? 0,
            stageAtInvestment: stageAtInvestment,
            currentStage: currentStage,
            boardSeat: boardSeat,
            boardMember: boardMember,
            notes: notes,
            website: website
        )
        portfolio.append(company)
        dismiss()
    }
}

#Preview {
    CreatePortfolioCompanyView(portfolio: .constant([]))
}


