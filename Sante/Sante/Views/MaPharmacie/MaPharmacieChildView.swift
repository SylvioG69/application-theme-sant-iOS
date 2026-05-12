import SwiftUI

struct MaPharmacieChildView: View {

    // MARK: - Propriétés

    var medicament: Medicament
    @Environment(\.dismiss) private var dismiss

    // MARK: - État local

    @State private var selectedIcon: String
    @State private var nom: String
    @State private var dose: Int
    @State private var numeroLot: String
    @State private var dateExpiration: Date
    @State private var notes: String
    @State private var showSavedToast  = false
    @State private var showDeleteAlert = false

    private let dateRange: ClosedRange<Date> = {
        let cal   = Calendar.current
        let start = cal.date(byAdding: .year, value: -10, to: Date())!
        let end   = cal.date(byAdding: .year, value: +10, to: Date())!
        return start...end
    }()

    private let icons: [(name: String, label: String)] = [
        ("pills.fill",      "Comprimé"),
        ("cross.vial.fill",    "Sirop"),
        ("drop.fill",       "Crème"),
    ]

    // MARK: - Init

    init(medicament: Medicament) {
        self.medicament  = medicament
        _nom             = State(initialValue: medicament.nomMedicament)
        _numeroLot       = State(initialValue: medicament.numeroLot)
        _dose            = State(initialValue: 1)
        _selectedIcon    = State(initialValue: "pills.fill")
        _notes           = State(initialValue: "")
        _dateExpiration  = State(
            initialValue: expirationDate(from: medicament.dateExpiration) ?? Date()
        )
    }

    // MARK: - Validation

    private var isFormValid: Bool {
        !nom.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    formeSection
                    informationsSection
                    dateExpirationSection
                    quantiteSection
                    notesSection
                    deleteButton
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGray6))
            .navigationTitle("Modifier")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) { saveButton }
            .overlay(alignment: .top)     { toastOverlay }
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showSavedToast)
            .alert("Supprimer \(nom) ?", isPresented: $showDeleteAlert) {
                Button("Supprimer", role: .destructive) { dismiss() }
                Button("Annuler",   role: .cancel)      {}
            } message: {
                Text("Cette action est irréversible.")
            }
        }
        .background(Color(.systemGray6))
    }

    // MARK: - Sections

    private var formeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Forme")
            HStack(spacing: 12) {
                ForEach(icons, id: \.name) { icon in
                    iconButton(icon.name, label: icon.label)
                }
            }
            .padding(14)
        }
    }

    private var informationsSection: some View {
        SectionCard(title: "Informations") {
            VStack(spacing: 12) {
                LabeledField(label: "Nom du médicament", systemImage: "cross.fill") {
                    TextField("Ex : Doliprane 1000mg", text: $nom)
                        .autocorrectionDisabled()
                }
                Divider()
                LabeledField(label: "Numéro de lot", systemImage: "number") {
                    TextField("Ex : AB12345", text: $numeroLot)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                }
            }
        }
    }

    private var dateExpirationSection: some View {
        SectionCard(title: "Date d'expiration") {
            HStack(spacing: 12) {

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("colorButton").opacity(0.15))
                        .frame(width: 38, height: 38)
                    Image(systemName: "calendar")
                        .foregroundStyle(Color("colorButton"))
                        .font(.system(size: 16, weight: .medium))
                }

                DatePicker(
                    "",
                    selection: $dateExpiration,
                    in: dateRange,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(Color("colorButton"))

                Spacer()

                let status = expirationStatus(from: dateExpiration)
                HStack(spacing: 4) {
                    Image(systemName: statusIcon(status))
                        .font(.system(size: 13, weight: .medium))
                    Text(statusMessage(status))
                        .font(.caption2)
                        .fontWeight(.medium)
                }
                .foregroundStyle(status.color)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(status.color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    private var quantiteSection: some View {
        SectionCard(title: "Quantité") {
            HStack {
                Image(systemName: "number.circle")
                    .foregroundStyle(Color("colorTexte"))
                Text("Nombre de doses")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Stepper(value: $dose, in: 1...999) {
                    Text("\(dose)")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("colorTexte"))
                        .frame(minWidth: 32, alignment: .trailing)
                }
            }
        }
    }

    private var notesSection: some View {
        SectionCard(title: "Notes") {
            TextField(
                "Informations supplémentaires, posologie...",
                text: $notes,
                axis: .vertical
            )
            .lineLimit(3...6)
            .font(.subheadline)
        }
    }

    private var deleteButton: some View {
        Button(role: .destructive) {
            showDeleteAlert = true
        } label: {
            Label("Supprimer ce médicament", systemImage: "trash")
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.08))
                .foregroundStyle(.red)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private var saveButton: some View {
        Button {
            saveChanges()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                Text("Sauvegarder")
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                isFormValid
                    ? Color("colorButton")
                    : Color.gray.opacity(0.5)
            )
            .cornerRadius(20)
            .padding(.horizontal, 16)
            .padding(.bottom, 17)
        }
        .disabled(!isFormValid)
    }

    @ViewBuilder
    private var toastOverlay: some View {
        if showSavedToast {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                Text("Modifications sauvegardées")
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.colorButton.opacity(0.9))
            .cornerRadius(20)
            .padding(.top, 8)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }

    // MARK: - Actions

    private func saveChanges() {
        guard isFormValid else { return }
        withAnimation { showSavedToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            dismiss()
        }
    }

    // MARK: - Expiration helpers (Date-based)

    private func expirationStatus(from date: Date) -> ExpirationStatus {
        let now       = Date()
        let twoMonths = Calendar.current.date(byAdding: .month, value: 2, to: now)!
        if date < now       { return .expired }
        if date < twoMonths { return .soon    }
        return .ok
    }

    private func statusIcon(_ status: ExpirationStatus) -> String {
        switch status {
        case .ok:      return "checkmark.circle.fill"
        case .soon:    return "exclamationmark.triangle.fill"
        case .expired: return "xmark.circle.fill"
        case .unknown: return "questionmark.circle"
        }
    }

    private func statusMessage(_ status: ExpirationStatus) -> String {
        switch status {
        case .ok:      return "Valide"
        case .soon:    return "Expire bientôt"
        case .expired: return "Expiré"
        case .unknown: return "Inconnu"
        }
    }

    // MARK: - Icon button

    private func iconButton(_ name: String, label: String) -> some View {
        Button {
            selectedIcon = name
        } label: {
            VStack(spacing: 6) {
                Image(systemName: name)
                    .font(.title3)
                Text(label)
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        selectedIcon == name
                            ? Color("colorTitre").opacity(0.6)
                        : Color.colorlist.opacity(0.5)
                    )
            )
            .foregroundColor(selectedIcon == name ? .white : .primary)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Section header

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .tracking(0.5)
    }
}

// MARK: - SectionCard

struct SectionCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .tracking(0.5)

            content
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color("colorlist").opacity(0.5))
                )
        }
    }
}

// MARK: - LabeledField

struct LabeledField<Content: View>: View {
    let label: String
    let systemImage: String
    @ViewBuilder let content: Content

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(Color("colorTexte").opacity(0.7))
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                content
                    .font(.subheadline)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    MaPharmacieChildView(medicament: maPharmacies[0])
}
