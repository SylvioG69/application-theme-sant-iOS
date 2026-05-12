import SwiftUI

struct MaPharmacieView: View {
    @State private var recherche = ""
    @State private var trierParExpiration = false

    var medicamentsFiltres: [Medicament] {
        var liste = recherche.isEmpty
            ? maPharmacies
            : maPharmacies.filter {
                $0.nomMedicament.localizedCaseInsensitiveContains(recherche)
            }

        if trierParExpiration {
            liste.sort {
                let d0 = expirationDate(from: $0.dateExpiration) ?? .distantFuture
                let d1 = expirationDate(from: $1.dateExpiration) ?? .distantFuture
                return d0 < d1
            }
        }

        return liste
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(medicamentsFiltres) { item in
                        NavigationLink {
                            MaPharmacieChildView(medicament: item)
                        } label: {
                            MedicamentCard(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .navigationTitle("Ma pharmacie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        trierParExpiration.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .symbolVariant(trierParExpiration ? .fill : .none)
                            .foregroundStyle(trierParExpiration ? Color("colorButton") : .primary)
                    }
                }
            }
            .searchable(
                text: $recherche,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Rechercher un médicament"
            )
            .safeAreaInset(edge: .bottom) {
                NavigationLink {
                    ScanChildView()
                } label: {
                    Label("Scanner un médicament", systemImage: "barcode.viewfinder")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("colorButton"))
                        .cornerRadius(20)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 17)
                }
            }
        }
    }
}

// MARK: - Helpers expiration

private func makeExpirationFormatter() -> DateFormatter {
    let f = DateFormatter()
    f.dateFormat = "MM/yyyy"
    return f
}

func expirationDate(from string: String) -> Date? {
    makeExpirationFormatter().date(from: string)
}

func expirationStatus(from string: String) -> ExpirationStatus {
    guard let date = expirationDate(from: string) else { return .unknown }
    let now = Date()
    let twoMonths = Calendar.current.date(byAdding: .month, value: 2, to: now) ?? now
    if date < now       { return .expired }
    if date < twoMonths { return .soon }
    return .ok
}

enum ExpirationStatus: Equatable {
    case ok, soon, expired, unknown

    var color: Color {
        switch self {
        case .ok:      return Color("colorTexte")
        case .soon:    return .orange
        case .expired: return .red
        case .unknown: return .secondary
        }
    }

    var badge: String? {
        switch self {
        case .soon:    return "Bientôt expiré"
        case .expired: return "Expiré"
        default:       return nil
        }
    }
}

// MARK: - Card

struct MedicamentCard: View {
    let item: Medicament

    var body: some View {
        let status = expirationStatus(from: item.dateExpiration)

        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.nomMedicament)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("colorTexte"))

                Text(item.quantiteMedicament)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("Lot : \(item.numeroLot)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let badge = status.badge {
                    Label(badge, systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(status.color)
                        .padding(.top, 2)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 16) {
                Text(item.dateExpiration)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(status.color)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(status.color.opacity(0.4), lineWidth: 1)
                    )

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.colorlist.opacity(0.5))
        )
        .overlay(alignment: .leading) {
            if status != .ok && status != .unknown {
                Rectangle()
                    .fill(status.color)
                    .frame(width: 4)
                    .padding(.vertical, 4)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    MaPharmacieView()
}
