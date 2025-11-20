import SwiftUI

struct CreateInvoiceView: View {
    @Binding var invoices: [Invoice]
    @Environment(\.dismiss) private var dismiss
    
    @State private var invoiceNumber = ""
    @State private var issueDate = Date()
    @State private var dueDate = Date().addingTimeInterval(30*24*60*60)
    @State private var clientName = ""
    @State private var clientEmail = ""
    @State private var clientPhone = ""
    @State private var clientAddress = ""
    @State private var clientCity = ""
    @State private var clientState = ""
    @State private var clientZipCode = ""
    @State private var clientCountry = "USA"
    @State private var items: [InvoiceItem] = []
    @State private var notes = ""
    @State private var showingAddItem = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Invoice Details") {
                    TextField("Invoice Number", text: $invoiceNumber)
                    DatePicker("Issue Date", selection: $issueDate, displayedComponents: .date)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
                
                Section("Client Information") {
                    TextField("Name", text: $clientName)
                    TextField("Email", text: $clientEmail)
                        .keyboardType(.emailAddress)
                    TextField("Phone", text: $clientPhone)
                        .keyboardType(.phonePad)
                    TextField("Address", text: $clientAddress)
                    TextField("City", text: $clientCity)
                    TextField("State", text: $clientState)
                    TextField("ZIP Code", text: $clientZipCode)
                    TextField("Country", text: $clientCountry)
                }
                
                Section("Items") {
                    ForEach(items) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.description)
                                .font(.headline)
                            HStack {
                                Text("Qty: \(String(format: "%.0f", item.quantity))")
                                Spacer()
                                Text("Price: $\(String(format: "%.2f", item.unitPrice))")
                                Spacer()
                                Text("Tax: \(String(format: "%.1f", item.taxRate))%")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                            Text("Total: $\(String(format: "%.2f", item.total))")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }
                    .onDelete(perform: deleteItems)
                    
                    Button(action: {
                        showingAddItem = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Item")
                        }
                    }
                }
                
                Section("Notes") {
                    TextField("Additional notes...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Summary") {
                    HStack {
                        Text("Subtotal:")
                        Spacer()
                        Text("$\(String(format: "%.2f", subtotal))")
                    }
                    HStack {
                        Text("Total Tax:")
                        Spacer()
                        Text("$\(String(format: "%.2f", totalTax))")
                    }
                    HStack {
                        Text("Total:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(String(format: "%.2f", total))")
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationTitle("Create Invoice")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveInvoice()
                    }
                    .disabled(invoiceNumber.isEmpty || clientName.isEmpty || items.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddItemView(items: $items)
            }
        }
    }
    
    private var subtotal: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }
    
    private var totalTax: Double {
        items.reduce(0) { $0 + $1.taxAmount }
    }
    
    private var total: Double {
        subtotal + totalTax
    }
    
    private func deleteItems(offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    private func saveInvoice() {
        let client = Client(
            name: clientName,
            email: clientEmail,
            phone: clientPhone,
            address: clientAddress,
            city: clientCity,
            state: clientState,
            zipCode: clientZipCode,
            country: clientCountry
        )
        
        let invoice = Invoice(
            invoiceNumber: invoiceNumber,
            issueDate: issueDate,
            dueDate: dueDate,
            client: client,
            items: items,
            notes: notes
        )
        
        invoices.append(invoice)
        dismiss()
    }
}

struct AddItemView: View {
    @Binding var items: [InvoiceItem]
    @Environment(\.dismiss) private var dismiss
    
    @State private var description = ""
    @State private var quantity = 1.0
    @State private var unitPrice = 0.0
    @State private var taxRate = 8.5
    
    var body: some View {
        NavigationView {
            Form {
                Section("Item Details") {
                    TextField("Description", text: $description)
                    HStack {
                        Text("Quantity")
                        Spacer()
                        TextField("Quantity", value: $quantity, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Unit Price")
                        Spacer()
                        TextField("Price", value: $unitPrice, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Tax Rate (%)")
                        Spacer()
                        TextField("Tax", value: $taxRate, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Preview") {
                    HStack {
                        Text("Subtotal:")
                        Spacer()
                        Text("$\(String(format: "%.2f", quantity * unitPrice))")
                    }
                    HStack {
                        Text("Tax Amount:")
                        Spacer()
                        Text("$\(String(format: "%.2f", (quantity * unitPrice) * (taxRate / 100)))")
                    }
                    HStack {
                        Text("Total:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(String(format: "%.2f", (quantity * unitPrice) * (1 + taxRate / 100)))")
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addItem()
                    }
                    .disabled(description.isEmpty || quantity <= 0 || unitPrice <= 0)
                }
            }
        }
    }
    
    private func addItem() {
        let item = InvoiceItem(
            description: description,
            quantity: quantity,
            unitPrice: unitPrice,
            taxRate: taxRate
        )
        items.append(item)
        dismiss()
    }
}

#Preview {
    CreateInvoiceView(invoices: .constant([]))
}
