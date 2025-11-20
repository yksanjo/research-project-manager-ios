import SwiftUI

struct InvoiceDetailView: View {
    let invoice: Invoice
    @State private var showingShareSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("INVOICE")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Text(invoice.invoiceNumber)
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(invoice.status.rawValue)
                                .font(.headline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(invoice.status.color).opacity(0.2))
                                .foregroundColor(Color(invoice.status.color))
                                .cornerRadius(12)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Issue Date")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(invoice.issueDate, style: .date)
                                .font(.body)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 8) {
                            Text("Due Date")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(invoice.dueDate, style: .date)
                                .font(.body)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Client Information
                VStack(alignment: .leading, spacing: 12) {
                    Text("Bill To")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(invoice.client.name)
                            .font(.body)
                            .fontWeight(.medium)
                        Text(invoice.client.email)
                            .font(.body)
                            .foregroundColor(.secondary)
                        Text(invoice.client.phone)
                            .font(.body)
                            .foregroundColor(.secondary)
                        Text(invoice.client.fullAddress)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Invoice Items
                VStack(alignment: .leading, spacing: 12) {
                    Text("Items")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 0) {
                        ForEach(invoice.items) { item in
                            InvoiceItemRow(item: item)
                            if item.id != invoice.items.last?.id {
                                Divider()
                            }
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
                
                // Totals
                VStack(alignment: .trailing, spacing: 8) {
                    HStack {
                        Text("Subtotal:")
                        Spacer()
                        Text("$\(String(format: "%.2f", invoice.subtotal))")
                    }
                    .font(.body)
                    
                    HStack {
                        Text("Tax:")
                        Spacer()
                        Text("$\(String(format: "%.2f", invoice.totalTax))")
                    }
                    .font(.body)
                    
                    Divider()
                    
                    HStack {
                        Text("Total:")
                            .fontWeight(.bold)
                        Spacer()
                        Text("$\(String(format: "%.2f", invoice.total))")
                            .fontWeight(.bold)
                            .font(.title2)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
                
                // Notes
                if !invoice.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(invoice.notes)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                }
            }
            .padding()
        }
        .navigationTitle("Invoice Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [generateInvoiceText()])
        }
    }
    
    private func generateInvoiceText() -> String {
        var text = "INVOICE \(invoice.invoiceNumber)\n"
        text += "Issue Date: \(invoice.issueDate, style: .date)\n"
        text += "Due Date: \(invoice.dueDate, style: .date)\n\n"
        text += "Bill To:\n\(invoice.client.name)\n\(invoice.client.fullAddress)\n\n"
        text += "Items:\n"
        for item in invoice.items {
            text += "\(item.description) - Qty: \(item.quantity) x $\(String(format: "%.2f", item.unitPrice)) = $\(String(format: "%.2f", item.subtotal))\n"
        }
        text += "\nSubtotal: $\(String(format: "%.2f", invoice.subtotal))\n"
        text += "Tax: $\(String(format: "%.2f", invoice.totalTax))\n"
        text += "Total: $\(String(format: "%.2f", invoice.total))"
        return text
    }
}

struct InvoiceItemRow: View {
    let item: InvoiceItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.description)
                    .font(.body)
                    .fontWeight(.medium)
                Text("Qty: \(String(format: "%.0f", item.quantity)) × $\(String(format: "%.2f", item.unitPrice))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(String(format: "%.2f", item.subtotal))")
                    .font(.body)
                    .fontWeight(.medium)
                Text("Tax: $\(String(format: "%.2f", item.taxAmount))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationView {
        InvoiceDetailView(invoice: Invoice(
            invoiceNumber: "INV-001",
            client: Client(name: "John Doe", email: "john@example.com", phone: "555-1234", address: "123 Main St", city: "Anytown", state: "CA", zipCode: "12345", country: "USA"),
            items: [
                InvoiceItem(description: "Web Design", quantity: 1, unitPrice: 1500.0, taxRate: 8.5),
                InvoiceItem(description: "Hosting (Monthly)", quantity: 12, unitPrice: 25.0, taxRate: 8.5)
            ],
            notes: "Thank you for your business!"
        ))
    }
}
