import SwiftUI

struct MedicamentScanne: Identifiable {
    let id = UUID()
    let expiration: String
    let nom: String
    let quantite: String
    let lot: String
}

let medicamentsDisponibles: [MedicamentScanne] = [
    MedicamentScanne(expiration: "10/28", nom: "Doliprane 1000mg",  quantite: "8 comprimés",  lot: "LX623"),
    MedicamentScanne(expiration: "11/26", nom: "Ibuprofène 200mg",  quantite: "15 comprimés", lot: "BU202"),
    MedicamentScanne(expiration: "03/26", nom: "Amoxicilline 1g",   quantite: "12 gélules",   lot: "MX202"),
    MedicamentScanne(expiration: "07/27", nom: "Vitamine C 500mg",  quantite: "30 comprimés", lot: "VC500"),
    MedicamentScanne(expiration: "01/26", nom: "Paracétamol 500mg", quantite: "16 comprimés", lot: "PR516"),
]

struct ScanChildView: View {

    @State private var medicamentsScannes: [MedicamentScanne] = []
    @State private var indexScan: Int = 0
    @State private var dernierId: UUID? = nil
    @State private var selectedMed: MedicamentScanne? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // ── Texte instruction ─────────────────────────────────
                Text("Placer votre médicament au centre de l'écran")
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 24)
                    .padding(.bottom, 24)

                // ── Caméra ────────────────────────────────────────────
                ZStack {
                    CameraView()
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white, lineWidth: 3)
                        )

                    Button {
                        simulerScan()
                    } label: {
                        Image(systemName: "viewfinder")
                            .font(.system(size: 100))
                            .foregroundStyle(.white)
                    }
                }

                Spacer()

                // ── Liste scannés ─────────────────────────────────────
                VStack(alignment: .leading, spacing: 12) {
                    
                    if medicamentsScannes.isEmpty {
                        Text("Scannez le \(Image(systemName:"qrcode")) sur une boîte de médicament ou le \(Image(systemName:"barcode")) à 13 chiffres")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    } else {
                        Text("Médicaments scannés")
                            .fontWeight(.medium)
                            .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(medicamentsScannes.reversed()) { med in
                                    CarteScannee(medicament: med, isNew: med.id == dernierId)
                                        .onTapGesture {
                                            selectedMed = med
                                        }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                }
                .padding(.bottom, 80)

            }
            
        }
        .sheet(item: $selectedMed) { med in
            DetailMedicamentSheet(medicament: med) {
                let nouveau = Medicament(
                    nomMedicament: med.nom,
                    quantiteMedicament: med.quantite,
                    numeroLot: med.lot,
                    dateExpiration: med.expiration
                )
                maPharmacies.append(nouveau)
            }
        }
    }

    private func simulerScan() {
        guard indexScan < medicamentsDisponibles.count else { return }
        let nouveau = medicamentsDisponibles[indexScan]
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            medicamentsScannes.append(nouveau)
            dernierId = nouveau.id
        }
        indexScan += 1
    }
}

// ── Sheet détail ──────────────────────────────────────────────────────────────
struct DetailMedicamentSheet: View {
    let medicament: MedicamentScanne
    var onAjouter: () -> Void

    @State private var dejaAjoute: Bool = false

    var body: some View {
        VStack(spacing: 0) {

            // ── Header ────────────────────────────────────────────────
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color("colorButton").opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: "pills.fill")
                        .font(.title2)
                        .foregroundColor(Color("colorButton"))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(medicament.nom)
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(2)
                    Text("Médicament scanné")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 20)

            Divider()

            // ── Infos ─────────────────────────────────────────────────
            VStack(spacing: 0) {

                InfoRow(icon: "cross.case.fill",      label: "Médicament",  value: medicament.nom)
                Divider().padding(.leading, 52)
                InfoRow(icon: "number.square.fill",   label: "Lot",         value: medicament.lot)
                Divider().padding(.leading, 52)
                InfoRow(icon: "pills.circle.fill",    label: "Quantité",    value: medicament.quantite)
                Divider().padding(.leading, 52)
                InfoRow(icon: "calendar.badge.clock", label: "Expiration",  value: medicament.expiration)

            }
            .padding(.vertical, 8)
            .background(Color("colorbackgroundList"))
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .padding(.top, 20)

            Spacer()

            // ── Bouton ajouter ────────────────────────────────────────
            Button {
                guard !dejaAjoute else { return }
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    dejaAjoute = true
                }
                onAjouter()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: dejaAjoute ? "checkmark.circle.fill" : "plus.circle.fill")
                    Text(dejaAjoute ? "Ajouté à Ma Pharmacie" : "Ajouter à Ma Pharmacie")
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(dejaAjoute ? Color.green : Color("colorButton"))
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: dejaAjoute)
        }
        .presentationDetents([.height(430)])
        .presentationCornerRadius(24)
        .presentationDragIndicator(.visible)
    }
}

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(Color("colorButton"))
                .frame(width: 24)
                .padding(.leading, 14)

            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.trailing, 14)
        }
        .frame(height: 52)
    }
}

// ── Carte ─────────────────────────────────────────────────────────────────────
struct CarteScannee: View {
    let medicament: MedicamentScanne
    let isNew: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "pills.fill")
                    .foregroundColor(Color("colorButton"))
                    .font(.caption)
                Spacer()
                Text("Exp: \(medicament.expiration)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Text(medicament.nom)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)

            Text(medicament.quantite)
                .font(.caption)
                .foregroundColor(.secondary)

            Text("Lot : \(medicament.lot)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(14)
        .frame(width: 160)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("colorbackgroundList"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    isNew ? Color("colorButton") : Color("colorButton").opacity(0.3),
                    lineWidth: isNew ? 2.5 : 1.5
                )
        )
        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
        .scaleEffect(isNew ? 1.03 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isNew)
    }
}

#Preview {
    ScanChildView()
}
