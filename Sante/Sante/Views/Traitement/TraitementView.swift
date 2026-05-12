import SwiftUI

// MARK: - Modèle

struct MedicamentPrise: Identifiable {
    let id = UUID()
    let nom: String
    let dosage: String
    let heure: String
    var pris: Bool
}

// MARK: - Couleur ambre

extension Color {
    static let ambre        = Color(red: 0.855, green: 0.459, blue: 0.067)
    static let ambreFond    = Color(red: 0.980, green: 0.933, blue: 0.855)
    static let ambreBordure = Color(red: 0.945, green: 0.765, blue: 0.459)
}

// MARK: - Vue principale

struct TraitementView: View {

    let prenomUtilisateur: String = "Marie"

    @State private var medicaments: [MedicamentPrise] = [
        .init(nom: "Doliprane", dosage: "1 comprimé · 500mg", heure: "08:00", pris: true),
        .init(nom: "Doliprane", dosage: "1 comprimé · 500mg", heure: "15:15", pris: true),
        .init(nom: "Doliprane", dosage: "1 comprimé · 500mg", heure: "20:00", pris: false)
    ]

    @State private var confirmationAnnulationID: UUID? = nil
    @State private var afficherListeTraitements: Bool  = false
    @State var traitements1 = mockTraitements

    // MARK: Calculs
    var prisCount:   Int { medicaments.filter {  $0.pris }.count }
    var manqueCount: Int { medicaments.filter { !$0.pris }.count }
    var pourcentage: Int { medicaments.isEmpty ? 0 : Int(Double(prisCount) / Double(medicaments.count) * 100) }

    var salutation: String {
        let h = Calendar.current.component(.hour, from: Date())
        switch h {
        case 5..<12:  return "Bonjour"
        case 12..<18: return "Bon après-midi"
        default:      return "Bonsoir"
        }
    }

    var dateFormatee: String {
        let f = DateFormatter()
        f.locale     = Locale(identifier: "fr_FR")
        f.dateFormat = "EEEE d MMMM"
        return f.string(from: Date()).capitalized
    }

    // MARK: Body
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {

                LinearGradient(
                    colors: [Color("colorButton").opacity(0.18), Color(.systemGroupedBackground)],
                    startPoint: .top,
                    endPoint: .init(x: 0.5, y: 0.38)
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {

                        enTete
                        carteResume
                        boutonMesTraitements
                            
                        
                        

                        // ── Prise du jour ──────────────────────────────
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Label("Prise du jour", systemImage: "list.bullet.rectangle.portrait")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 4)

                            ForEach($medicaments) { $m in
                                MedicamentRow(
                                    medicament: $m,
                                    demandeConfirmationAnnulation: confirmationAnnulationID == m.id,
                                    onAnnuler: {
                                        withAnimation { confirmationAnnulationID = m.id }
                                    },
                                    onConfirmerAnnulation: {
                                        withAnimation {
                                            if let idx = medicaments.firstIndex(where: { $0.id == m.id }) {
                                                medicaments[idx].pris = false
                                            }
                                            confirmationAnnulationID = nil
                                        }
                                    },
                                    onAnnulerConfirmation: {
                                        withAnimation { confirmationAnnulationID = nil }
                                    }
                                )
                            }
                        }

                        // ── Mes traitements ────────────────────────────
                        

                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
            }
            .navigationBarHidden(true)
            .safeAreaInset(edge: .bottom) { boutonAjouter }
            .sheet(isPresented: $afficherListeTraitements) {
                ListeTraitementsView(traitements: $traitements1)
            }
        }
    }

    // MARK: - Sous-vues

    private var enTete: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(salutation + ",")
                .font(.title3)
                .foregroundColor(Color("colorButton").opacity(0.9))
            Text(prenomUtilisateur)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            Text(dateFormatee)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var carteResume: some View {
        HStack(spacing: 0) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.25), lineWidth: 6)
                    .frame(width: 70, height: 70)
                Circle()
                    .trim(from: 0, to: CGFloat(pourcentage) / 100)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 70, height: 70)
                VStack(spacing: 0) {
                    Text("\(pourcentage)%")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Suivi")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.75))
                }
            }
            .padding(.trailing, 18)

            VStack(alignment: .leading, spacing: 8) {
                statLigne(
                    icone: "checkmark.circle.fill",
                    couleur: .white,
                    texte: "\(prisCount) prise\(prisCount > 1 ? "s" : "") confirmée\(prisCount > 1 ? "s" : "")",
                    couleurTexte: .white
                )
                statLigne(
                    icone: "exclamationmark.circle.fill",
                    couleur: manqueCount > 0 ? .red : .white.opacity(0.6),
                    texte: "\(manqueCount) prise\(manqueCount > 1 ? "s" : "") manquée\(manqueCount > 1 ? "s" : "")",
                    couleurTexte: manqueCount > 0 ? Color(red: 1, green: 0.6, blue: 0.6) : .white
                )
                statLigne(
                    icone: "pills.fill",
                    couleur: .white.opacity(0.85),
                    texte: "\(medicaments.count) médicament\(medicaments.count > 1 ? "s" : "") au total",
                    couleurTexte: .white
                )
            }
            Spacer()
        }
        .padding(20)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 22).fill(Color("colorButton"))
                RoundedRectangle(cornerRadius: 22)
                    .fill(LinearGradient(
                        colors: [Color.white.opacity(0.15), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            }
        )
        .shadow(color: Color("colorButton").opacity(0.35), radius: 14, x: 0, y: 6)
    }

    private func statLigne(icone: String, couleur: Color, texte: String, couleurTexte: Color) -> some View {
        HStack(spacing: 7) {
            Image(systemName: icone).font(.caption).foregroundColor(couleur)
            Text(texte).font(.subheadline).foregroundColor(couleurTexte)
        }
    }

    private var boutonMesTraitements: some View {
        Button(action: { afficherListeTraitements = true }) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("colorButton").opacity(0.15))
                        .frame(width: 32, height: 32)
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("colorButton"))
                }

                VStack(alignment: .leading, spacing: 1) {
                    Text("Mes traitements")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text("Voir et gérer tous vos traitements")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("colorButton").opacity(0.15), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private var boutonAjouter: some View {
        NavigationLink {
            AjoutTraitementView(traitements: $traitements1)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill").font(.title3)
                Text("Ajouter un traitement").fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color("colorButton"))
            .cornerRadius(22)
            .shadow(color: Color("colorButton").opacity(0.4), radius: 10, x: 0, y: 4)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Ligne médicament

struct MedicamentRow: View {
    @Binding var medicament: MedicamentPrise

    var demandeConfirmationAnnulation: Bool
    var onAnnuler: () -> Void
    var onConfirmerAnnulation: () -> Void
    var onAnnulerConfirmation: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack(spacing: 14) {

                ZStack {
                    Circle()
                        .fill(medicament.pris
                              ? Color("colorButton").opacity(0.13)
                              : Color.ambreFond)
                        .frame(width: 44, height: 44)
                    Circle()
                        .strokeBorder(
                            medicament.pris ? Color("colorButton").opacity(0.2) : Color.ambreBordure,
                            lineWidth: 1
                        )
                        .frame(width: 44, height: 44)
                    Image(systemName: medicament.pris ? "hands.and.sparkles.fill" : "clock.fill")
                        .foregroundColor(medicament.pris ? Color("colorButton") : Color.ambre)
                        .font(.system(size: 18))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(medicament.nom).font(.headline)
                    Text(medicament.dosage).font(.subheadline).foregroundColor(.secondary)
                    if medicament.pris {
                        Label("Pris à \(medicament.heure)", systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    Text(medicament.pris ? "Pris" : medicament.heure)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(medicament.pris ? Color("colorButton") : Color.ambre)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            (medicament.pris ? Color("colorButton") : Color.ambre).opacity(0.12)
                        )
                        .cornerRadius(20)

                    if medicament.pris && !demandeConfirmationAnnulation {
                        Button(action: onAnnuler) {
                            Text("Annuler")
                                .font(.caption)
                                .foregroundColor(.secondary.opacity(0.7))
                                .underline()
                        }
                        .buttonStyle(.plain)
                        .transition(.opacity)
                    }
                }
            }

            if demandeConfirmationAnnulation {
                HStack(spacing: 8) {
                    Image(systemName: "questionmark.circle")
                        .font(.caption)
                        .foregroundColor(Color.ambre)
                    Text("Annuler cette prise ?")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Button(action: onAnnulerConfirmation) {
                        Text("Non")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("colorButton"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color("colorButton").opacity(0.10))
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)

                    Button(action: onConfirmerAnnulation) {
                        Text("Oui")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.ambre)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            if !medicament.pris {
                Button(action: { medicament.pris = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark").font(.caption.bold())
                        Text("Marquer comme pris").font(.subheadline).fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.colorButton.opacity(0.8))
                    .cornerRadius(16)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    medicament.pris
                    ? (demandeConfirmationAnnulation ? Color.ambreBordure : Color.clear)
                    : Color.ambreBordure.opacity(0.6),
                    lineWidth: 1.5
                )
        )
        .animation(.easeInOut(duration: 0.18), value: demandeConfirmationAnnulation)
        .animation(.easeInOut(duration: 0.18), value: medicament.pris)
    }
}

// MARK: - Liste des traitements (sheet)

struct GroupeTraitement: Identifiable {
    let id = UUID()
    let nom: String
    let traitements: [Traitement]
}

struct ListeTraitementsView: View {

    @Environment(\.dismiss) private var dismiss
    @Binding var traitements: [Traitement]

    @State private var editingID: UUID? = nil

    var traitementsGroupes: [String: [Traitement]] {
        Dictionary(grouping: traitements) { $0.nomTraitement }
    }

    var traitementsTries: [(key: String, value: [Traitement])] {
        traitementsGroupes.sorted { $0.key < $1.key }
    }

    let moments    = ["Avant repas", "Après repas", "À jeun"]
    
        let frequences = [
            "Jamais",
            "1 fois par jour",
            "2 fois par jour",
            "3 fois par jour",
            "Tous les jours",
            "Jours de semaine",
            "Week-ends",
            "Toutes les semaines",
            "Toutes les 2 semaines",
            "Tous les mois",
            "Tous les 3 mois",
            "Tous les 6 mois",
            "Tous les ans"
        ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(traitementsTries, id: \.key) { groupe in
                    Section(header: Text(groupe.key)) {
                        ForEach(groupe.value) { traitement in
                            if let index = traitements.firstIndex(where: { $0.id == traitement.id }) {
                                VStack(alignment: .leading, spacing: 10) {

                                    HStack {
                                        Image(systemName: traitement.imageTraitement)
                                            .foregroundColor(Color("colorButton"))
                                        Text(traitement.traitementName)
                                            .font(.headline)
                                        Spacer()
                                        Button {
                                            withAnimation {
                                                editingID = (editingID == traitement.id) ? nil : traitement.id
                                            }
                                        } label: {
                                            Image(systemName: editingID == traitement.id
                                                  ? "checkmark.circle.fill"
                                                  : "pencil.circle.fill")
                                                .font(.title3)
                                                .foregroundColor(Color("colorButton"))
                                        }
                                    }

                                    if editingID == traitement.id {
                                        Stepper(
                                            "Dose: \(traitements[index].nombreDose)",
                                            value: $traitements[index].nombreDose,
                                            in: 1...10
                                        )
                                        Picker("Moment", selection: $traitements[index].momentPrise) {
                                            ForEach(moments, id: \.self) { Text($0) }
                                        }
                                        .pickerStyle(.menu)

                                        Picker("Fréquence", selection: $traitements[index].frequence) {
                                            ForEach(frequences, id: \.self) { Text($0) }
                                        }
                                        .pickerStyle(.menu)

                                    } else {
                                        Text("Dose: \(traitement.nombreDose)").font(.headline)
                                        Text(traitement.momentPrise).font(.headline).foregroundColor(.primary)
                                        Text(traitement.frequence).font(.headline).foregroundColor(.primary)
                                    }

                                    Text(traitements[index].momentJournee)
                                        .font(.caption)
                                        .padding(6)
                                        .background(Color("colorButton").opacity(0.1))
                                        .cornerRadius(10)
                                }
                                .padding(.vertical, 6)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Mes traitements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fermer") { dismiss() }
                        .foregroundColor(Color("colorButton"))
                }
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        AjoutTraitementView(traitements: $traitements)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    TraitementView()
}
