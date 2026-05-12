import SwiftUI
import MapKit

struct RecyclageView: View {
    
    @State private var searchText = ""
    @State private var selectedPoint: PointCollecte? = nil
    @State private var navigateToMap = false
    @State private var mapTargetPoint: PointCollecte? = nil
    
    // 🔍 Normalisation texte
    func normalize(_ text: String) -> String {
        text.folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
    }
    
    // 🕒 ouvert ou fermer
    func isOpen(_ point: PointCollecte) -> Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= 8 && hour < 20
    }
    
    // 🔎 Filtre
    var filteredPoints: [PointCollecte] {
        if searchText.isEmpty {
            return pointsCollecte
        } else {
            return pointsCollecte.filter {
                normalize($0.nomePharmacie).contains(normalize(searchText)) ||
                normalize($0.adressePharmacie).contains(normalize(searchText)) ||
                normalize($0.codePostaleVille).contains(normalize(searchText))
            }
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 14) {
                    
                    Text("Recyclez vos médicaments non utilisés")
                        .foregroundStyle(.secondary)
                    
                    // 🔍 SEARCH BAR
                    /*HStack {
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Rechercher une pharmacie", text: $searchText)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)*/
                        .searchable(
                            text: $searchText,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: "Rechercher une pharmacie"
                        )

                }
                
                // 📍 LISTE
                VStack(spacing: 14) {
                    
                    ForEach(filteredPoints) { point in
                        
                        Button {
                            selectedPoint = point
                        } label: {
                            
                            HStack(spacing: 14) {
                                
                                // 🖼️ IMAGE
                                Image(point.photoPharmacie)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .clipped()
                                    .cornerRadius(14)
                                
                                // 📄 INFOS
                                VStack(alignment: .leading, spacing: 6) {
                                    
                                    Text(point.nomePharmacie)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                    
                                    // 🟢 / 🔴 BADGE
                                    HStack(spacing: 6) {
                                        
                                        Circle()
                                            .fill(isOpen(point) ? Color.green : Color.red)
                                            .frame(width: 8, height: 8)
                                        
                                        Text(isOpen(point) ? "Ouvert" : "Fermé")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(isOpen(point) ? .green : .red)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(
                                        isOpen(point)
                                        ? Color.green.opacity(0.12)
                                        : Color.red.opacity(0.12)
                                    )
                                    .cornerRadius(10)
                                    
                                    Text(point.adressePharmacie)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                    
                                    HStack(spacing: 6) {
                                        
                                        Label(point.distancePharmacie,
                                              systemImage: "location.fill")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        
                                        Text("•")
                                            .foregroundColor(.gray)
                                        
                                        Text(point.horairePharmacie)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.08),
                                            radius: 6,
                                            x: 0,
                                            y: 2)
                            )
                            .padding(.horizontal)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom)
            }
            
            // 🧭 NAVIGATION MAP
            .navigationTitle("Recyclage")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        mapTargetPoint = nil
                        navigateToMap = true
                    } label: {
                        Image(systemName: "map")
                            .foregroundStyle(.colorTitre)
                    }
                }
            }
            
            .navigationDestination(isPresented: $navigateToMap) {
                MapView(focusedPoint: mapTargetPoint)
            }
            
            // 📄 SHEET
            .sheet(item: $selectedPoint) { point in
                
                VStack(spacing: 0) {
                    
                    ZStack(alignment: .topTrailing) {
                        
                        Image(point.photoPharmacie)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                        
                        Button {
                            selectedPoint = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(
                                    Color.black,
                                    Color.white.opacity(0.60)
                                )                                .padding(EdgeInsets(top: 50, leading: 20, bottom: 0, trailing: 20))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 14) {
                        
                        Text(point.nomePharmacie)
                            .font(.title2)
                            .bold()
                        
                        // 🟢 / 🔴 SHEET BADGE
                        HStack {
                            
                            Circle()
                                .fill(isOpen(point) ? Color.green : Color.red)
                                .frame(width: 10, height: 10)
                            
                            Text(isOpen(point) ? "Ouvert actuellement" : "Fermé actuellement")
                                .foregroundColor(isOpen(point) ? .green : .red)
                                .font(.subheadline)
                        }
                        
                        Label(point.adressePharmacie,
                              systemImage: "mappin.and.ellipse")
                        
                        Label(point.codePostaleVille,
                              systemImage: "building.2")
                        
                        Label(point.horairePharmacie,
                              systemImage: "clock")
                        
                        Button {
                            if let url = URL(string: "tel://\(point.numero)") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Label(point.numero, systemImage: "phone.fill")
                                .foregroundColor(.colorTitre)
                        }
                        
                        Button {
                            selectedPoint = nil
                            mapTargetPoint = point
                            navigateToMap = true
                        } label: {
                            Text("Voir sur la carte")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.colorTitre)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                .presentationDetents([.height(420)])
                .presentationCornerRadius(24)
            }
        }
    }
}

#Preview {
    RecyclageView()
}
