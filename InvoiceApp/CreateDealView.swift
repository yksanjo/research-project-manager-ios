import SwiftUI

struct CreateDealView: View {
    @Binding var deals: [Deal]
    @Environment(\.dismiss) var dismiss
    
    @State private var companyName = ""
    @State private var description = ""
    @State private var stage: DealStage = .sourcing
    @State private var sector = ""
    @State private var dealSize = ""
    @State private var valuation = ""
    @State private var leadInvestor = ""
    @State private var probability = 0
    @State private var investmentThesis = ""
    @State private var concerns = ""
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
                
                Section(header: Text("Deal Details")) {
                    Picker("Stage", selection: $stage) {
                        ForEach(DealStage.allCases, id: \.self) { stage in
                            Text(stage.rawValue).tag(stage)
                        }
                    }
                    
                    TextField("Deal Size", text: $dealSize)
                        .keyboardType(.decimalPad)
                    
                    TextField("Valuation", text: $valuation)
                        .keyboardType(.decimalPad)
                    
                    TextField("Lead Investor", text: $leadInvestor)
                    
                    VStack(alignment: .leading) {
                        Text("Probability: \(probability)%")
                        Slider(value: Binding(
                            get: { Double(probability) },
                            set: { probability = Int($0) }
                        ), in: 0...100, step: 5)
                    }
                }
                
                Section(header: Text("Investment Analysis")) {
                    TextField("Investment Thesis", text: $investmentThesis, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("Concerns", text: $concerns, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Deal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveDeal()
                    }
                    .disabled(companyName.isEmpty)
                }
            }
        }
    }
    
    private func saveDeal() {
        let deal = Deal(
            companyName: companyName,
            description: description,
            stage: stage,
            sector: sector,
            dealSize: Double(dealSize) ?? 0,
            valuation: Double(valuation) ?? 0,
            leadInvestor: leadInvestor,
            probability: probability,
            investmentThesis: investmentThesis,
            concerns: concerns,
            notes: notes,
            website: website
        )
        deals.append(deal)
        dismiss()
    }
}

#Preview {
    CreateDealView(deals: .constant([]))
}


