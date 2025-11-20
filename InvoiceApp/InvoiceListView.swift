import SwiftUI

struct InvoiceListView: View {
    @Binding var invoices: [Invoice]
    @State private var searchText = ""
    
    var filteredInvoices: [Invoice] {
        if searchText.isEmpty {
            return invoices
        } else {
            return invoices.filter { invoice in
                invoice.invoiceNumber.localizedCaseInsensitiveContains(searchText) ||
                invoice.client.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredInvoices) { invoice in
                NavigationLink(destination: InvoiceDetailView(invoice: invoice)) {
                    InvoiceRowView(invoice: invoice)
                }
            }
            .onDelete(perform: deleteInvoices)
        }
        .searchable(text: $searchText, prompt: "Search invoices...")
        .overlay(
            Group {
                if filteredInvoices.isEmpty {
                    if invoices.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "doc.text")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("No Invoices Yet")
                                .font(.title2)
                                .foregroundColor(.gray)
                            Text("Create your first invoice to get started")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    } else {
                        Text("No invoices match your search")
                            .foregroundColor(.gray)
                    }
                }
            }
        )
    }
    
    private func deleteInvoices(offsets: IndexSet) {
        invoices.remove(atOffsets: offsets)
    }
}

struct InvoiceRowView: View {
    let invoice: Invoice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(invoice.invoiceNumber)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(invoice.client.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("$\(String(format: "%.2f", invoice.total))")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(invoice.status.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(invoice.status.color).opacity(0.2))
                        .foregroundColor(Color(invoice.status.color))
                        .cornerRadius(8)
                }
            }
            
            HStack {
                Text(invoice.issueDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Due: \(invoice.dueDate, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationView {
        InvoiceListView(invoices: .constant([]))
    }
}
