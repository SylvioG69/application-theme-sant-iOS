//
//  PointCollecteData.swift
//  Sante
//
//  Created by appreant98 on 29/04/2026.
//

import Foundation
import SwiftUI

struct PointCollecte: Identifiable {
    var id = UUID()
    var photoPharmacie: ImageResource
    var nomePharmacie: String
    var distancePharmacie: String
    var adressePharmacie: String
    var codePostaleVille: String
    var horairePharmacie: String
    var latitude: Double
    var longitude: Double
    var numero: String
}


var pointsCollecte: [PointCollecte] = [
    
    PointCollecte(
        photoPharmacie: .pharmacie,
        nomePharmacie: "Pharmacie Centrale",
        distancePharmacie: "0.5 km",
        adressePharmacie: "10 Rue de la République",
        codePostaleVille: "69002 Lyon",
        horairePharmacie: "8h30 - 20h00",
        latitude: 45.764043,
        longitude: 4.835659,
        numero: "0478123456"
    ),
    
    PointCollecte(
        photoPharmacie: .pharmacie2,
        nomePharmacie: "Pharmacie Bellecour",
        distancePharmacie: "1.2 km",
        adressePharmacie: "5 Place Bellecour",
        codePostaleVille: "69002 Lyon",
        horairePharmacie: "9h00 - 19h30",
        latitude: 45.757813,
        longitude: 4.832011,
        numero: "0478567890"
    ),
    
    PointCollecte(
        photoPharmacie: .pharmacie3,
        nomePharmacie: "Pharmacie Part-Dieu",
        distancePharmacie: "2.0 km",
        adressePharmacie: "Centre Commercial Part-Dieu",
        codePostaleVille: "69003 Lyon",
        horairePharmacie: "8h00 - 21h00",
        latitude: 45.760696,
        longitude: 4.861133,
        numero: "0478987456"
    ),
    
    PointCollecte(
        photoPharmacie: .pharmacie4,
        nomePharmacie: "Pharmacie Croix-Rousse",
        distancePharmacie: "1.8 km",
        adressePharmacie: "12 Grande Rue de la Croix-Rousse",
        codePostaleVille: "69004 Lyon",
        horairePharmacie: "9h00 - 20h00",
        latitude: 45.774487,
        longitude: 4.829640,
        numero: "0478987456"
    ),
    
    PointCollecte(
        photoPharmacie: .pharmacie5,
        nomePharmacie: "Pharmacie Confluence",
        distancePharmacie: "3.1 km",
        adressePharmacie: "112 Cours Charlemagne",
        codePostaleVille: "69002 Lyon",
        horairePharmacie: "8h30 - 19h00",
        latitude: 45.741409,
        longitude: 4.815747,
        numero: "0478776655"
    )
]
