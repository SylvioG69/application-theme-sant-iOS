//
//  MaPharmacieData.swift
//  Sante
//
//  Created by appreant98 on 29/04/2026.
//

import Foundation

struct Medicament: Identifiable {
    var id = UUID()
    var nomMedicament: String
    var quantiteMedicament: String
    var numeroLot: String
    var dateExpiration: String
}

var maPharmacies: [Medicament] = [
    
    Medicament(
        nomMedicament: "Doliprane 1000 mg",
        quantiteMedicament: "8 comprimés",
        numeroLot: "LX623",
        dateExpiration: "10/2028"
    ),
    
    Medicament(
        nomMedicament: "Ibuprofène 200 mg",
        quantiteMedicament: "15 comprimés",
        numeroLot: "BU202",
        dateExpiration: "06/2026"
    ),
    
    Medicament(
        nomMedicament: "Amoxicilline 1g",
        quantiteMedicament: "12 gélules",
        numeroLot: "MX202",
        dateExpiration: "03/2026"
    ),
    
    Medicament(
        nomMedicament: "Sirop Toux 150 ml",
        quantiteMedicament: "1 sirop",
        numeroLot: "IR202",
        dateExpiration: "09/2026"
    ),
    
    Medicament(
        nomMedicament: "Crème dermatologique 30 g",
        quantiteMedicament: "1 tube",
        numeroLot: "RM202",
        dateExpiration: "12/2026"
    ),
    
    Medicament(
        nomMedicament: "Spray nasal 10 ml",
        quantiteMedicament: "1 flacon",
        numeroLot: "PR202",
        dateExpiration: "05/2027"
    )
]
