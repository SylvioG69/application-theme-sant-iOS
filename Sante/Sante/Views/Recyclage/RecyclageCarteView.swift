import SwiftUI
import MapKit
import CoreLocation
import Combine

// ─────────────────────────────────────────────
// 📍 GESTIONNAIRE DE LOCALISATION
// ─────────────────────────────────────────────

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // Gestionnaire GPS
    private let manager = CLLocationManager()
    
    // Position utilisateur
    @Published var userLocation: CLLocation? = nil
    
    // Statut autorisation
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        
        manager.delegate = self
        
        // Précision GPS
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Demande accès localisation
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    // Vérifie autorisation utilisateur
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        authorizationStatus = manager.authorizationStatus
        
        // Si autorisé → démarre localisation
        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            
            manager.startUpdatingLocation()
        }
    }
    
    // Mise à jour position utilisateur
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        userLocation = locations.last
    }
}

// ─────────────────────────────────────────────
// 🗺️ VUE CARTE
// ─────────────────────────────────────────────

struct MapView: View {
    
    // Pharmacie ciblée depuis RecyclageView
    var focusedPoint: PointCollecte? = nil
    
    // Gestionnaire GPS
    @StateObject private var locationManager = LocationManager()
    
    // Position de la caméra
    @State private var position: MapCameraPosition
    
    // Pharmacie sélectionnée
    @State private var selectedPoint: PointCollecte? = nil
    
    // ─────────────────────────
    // INITIALISATION
    // ─────────────────────────
    
    init(focusedPoint: PointCollecte? = nil) {
        
        self.focusedPoint = focusedPoint
        
        let center: CLLocationCoordinate2D
        
        // Si pharmacie ciblée
        if let p = focusedPoint {
            
            center = CLLocationCoordinate2D(
                latitude: p.latitude,
                longitude: p.longitude
            )
            
        } else {
            
            // Centre par défaut
            center = CLLocationCoordinate2D(
                latitude: 45.764043,
                longitude: 4.835659
            )
        }
        
        // Position initiale carte
        _position = State(initialValue: .region(
            MKCoordinateRegion(
                center: center,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.02,
                    longitudeDelta: 0.02
                )
            )
        ))
    }
    
    // ─────────────────────────
    // BODY
    // ─────────────────────────
    
    var body: some View {
        
        Map(position: $position) {
            
            // 📍 Position utilisateur
            UserAnnotation()
            
            // 📌 Pins pharmacies
            ForEach(pointsCollecte) { point in
                
                Annotation(
                    point.nomePharmacie,
                    coordinate: CLLocationCoordinate2D(
                        latitude: point.latitude,
                        longitude: point.longitude
                    )
                ) {
                    
                    // Bouton pin
                    Button {
                        
                        // Animation ouverture fiche
                        withAnimation(.spring(
                            response: 0.3,
                            dampingFraction: 0.7
                        )) {
                            selectedPoint = point
                        }
                        
                    } label: {
                        
                        ZStack {
                            
                            // Cercle
                            Circle()
                                .fill(Color("colorButton"))
                                .frame(width: 28, height: 28)
                                .shadow(
                                    color: Color("colorButton").opacity(0.4),
                                    radius: 5,
                                    x: 0,
                                    y: 2
                                )
                            
                            // Croix pharmacie
                            Image(systemName: "cross.fill")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        // Animation zoom pin
                        .scaleEffect(
                            selectedPoint?.id == point.id ? 1.2 : 1.0
                        )
                        .animation(
                            .spring(response: 0.3,
                                    dampingFraction: 0.6),
                            value: selectedPoint?.id
                        )
                    }
                }
            }
        }
        
        // ─────────────────────────
        // CONTRÔLES CARTE
        // ─────────────────────────
        
        .mapControls {
            
            // Bouton recentrage utilisateur
            MapUserLocationButton()
            
            // Échelle carte
            MapScaleView()
        }
        
        // Plein écran
        .ignoresSafeArea()
        
        // Titre
        .navigationTitle("Recyclage")
        .navigationBarTitleDisplayMode(.inline)
        
        // ─────────────────────────
        // AU LANCEMENT
        // ─────────────────────────
        
        .onAppear {
            
            // Demande GPS
            locationManager.requestPermission()
            
            // Ouvre fiche pharmacie automatiquement
            if let p = focusedPoint {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    selectedPoint = p
                }
            }
        }
        
        // ─────────────────────────
        // POSITION UTILISATEUR
        // ─────────────────────────
        
        .onChange(of: locationManager.userLocation) { _, location in
            
            // Ne recentre pas si pharmacie ciblée
            guard focusedPoint == nil,
                  let coordinate = location?.coordinate else { return }
            
            withAnimation {
                
                position = .region(
                    MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(
                            latitudeDelta: 0.05,
                            longitudeDelta: 0.05
                        )
                    )
                )
            }
        }
        
        // ─────────────────────────
        // 📄 FICHE PHARMACIE
        // ─────────────────────────
        
        .sheet(item: $selectedPoint) { point in
            
            VStack(spacing: 0) {
                
                // ─────────────────
                // 🖼️ IMAGE
                // ─────────────────
                
                ZStack(alignment: .topTrailing) {
                    
                    Image(point.photoPharmacie)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .clipped()
                    
                    // ❌ Bouton fermer
                    Button {
                        selectedPoint = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(
                                Color.black,
                                Color.white.opacity(0.60)
                            )
                            .padding(25)
                    }
                }
                
                // ─────────────────
                // 📄 INFOS
                // ─────────────────
                
                VStack(alignment: .leading, spacing: 18) {
                    
                    // 🏥 Nom pharmacie
                    Text(point.nomePharmacie)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // 📍 Adresse
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Label {
                            Text(point.adressePharmacie)
                        } icon: {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(Color("colorButton"))
                        }
                        
                        Label {
                            Text(point.codePostaleVille)
                        } icon: {
                            Image(systemName: "building.2")
                                .foregroundColor(Color("colorButton"))
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    // 📏 Distance
                    Label(point.distancePharmacie,
                          systemImage: "location.fill")
                    .font(.subheadline)
                    .foregroundColor(Color("colorButton"))
                    
                    // 📞 Numéro téléphone
                    Button {
                        
                        if let url = URL(
                            string: "tel://\(point.numero)"
                        ) {
                            UIApplication.shared.open(url)
                        }
                        
                    } label: {
                        
                        HStack {
                            
                            Image(systemName: "phone.fill")
                            
                            Text(point.numero)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(Color("colorButton"))
                    }
                    
                    // ⏰ Horaires
                    Label(
                        point.horairePharmacie,
                        systemImage: "clock.fill"
                    )
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Color("colorButton").opacity(0.12)
                    )
                    .foregroundColor(Color("colorButton"))
                    .cornerRadius(10)
                    
                    // ─────────────────
                    // 🚗 BOUTONS ACTIONS
                    // ─────────────────
                    
                    HStack(spacing: 12) {
                        
                        // 🚗 Itinéraire
                        Button {
                            
                            let coords = "\(point.latitude),\(point.longitude)"
                            
                            let name = point.nomePharmacie
                                .addingPercentEncoding(
                                    withAllowedCharacters: .urlQueryAllowed
                                ) ?? ""
                            
                            if let url = URL(
                                string: "maps://?daddr=\(coords)&q=\(name)"
                            ) {
                                UIApplication.shared.open(url)
                            }
                            
                        } label: {
                            
                            VStack(spacing: 6) {
                                
                                Image(systemName: "car.fill")
                                    .font(.title3)
                                
                                Text("Itinéraire")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color("colorButton"))
                            .foregroundColor(.white)
                            .cornerRadius(16)
                        }
                        
                        // 📞 Appeler
                        Button {
                            
                            if let url = URL(
                                string: "tel://\(point.numero)"
                            ) {
                                UIApplication.shared.open(url)
                            }
                            
                        } label: {
                            
                            VStack(spacing: 6) {
                                
                                Image(systemName: "phone.fill")
                                    .font(.title3)
                                
                                Text("Appeler")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.12))
                            .foregroundColor(.primary)
                            .cornerRadius(16)
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Taille fiche
            .presentationDetents([.height(500)])
            
            // Coins arrondis
            .presentationCornerRadius(30)
        }
    }
}



#Preview {
    NavigationStack {
        MapView()
    }
}
