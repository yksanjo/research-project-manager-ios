import SwiftUI

struct CreateThesisView: View {
    @Binding var theses: [InvestmentThesis]
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var sector = ""
    @State private var status: ThesisStatus = .active
    @State private var thesisPoints: [ThesisPoint] = []
    @State private var newPoint = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Thesis Information")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("Sector", text: $sector)
                    
                    Picker("Status", selection: $status) {
                        ForEach(ThesisStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                }
                
                Section(header: Text("Thesis Points")) {
                    ForEach(thesisPoints) { point in
                        HStack {
                            Text(point.point)
                                .font(.subheadline)
                            Spacer()
                            if point.validated {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .onDelete(perform: deletePoints)
                    
                    HStack {
                        TextField("Add thesis point", text: $newPoint)
                        Button("Add") {
                            if !newPoint.isEmpty {
                                thesisPoints.append(ThesisPoint(point: newPoint))
                                newPoint = ""
                            }
                        }
                        .disabled(newPoint.isEmpty)
                    }
                }
            }
            .navigationTitle("New Investment Thesis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveThesis()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func deletePoints(at offsets: IndexSet) {
        thesisPoints.remove(atOffsets: offsets)
    }
    
    private func saveThesis() {
        let thesis = InvestmentThesis(
            title: title,
            description: description,
            sector: sector,
            thesisPoints: thesisPoints,
            status: status
        )
        theses.append(thesis)
        dismiss()
    }
}

#Preview {
    CreateThesisView(theses: .constant([]))
}


