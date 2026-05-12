//
//  TraitementData.swift
//  Sante
//
//  Created by appreant98 on 29/04/2026.
//

import Foundation
import SwiftUI

struct Traitement: Identifiable {
    var id = UUID()
    var nomTraitement: String
    var imageTraitement: String
    var traitementName: String
    var nombreDose: Int
    var momentPrise: String
    var frequence: String
    var momentJournee: String
}


let mockTraitements: [Traitement] = [
    
    Traitement(
        nomTraitement: "Grippe",
        imageTraitement: "pills.fill", // à ajouter dans Assets
        traitementName: "Doliprane 500 mg",
        nombreDose: 1,
        momentPrise: "Après repas",
        frequence: "3 fois par jour",
        momentJournee: "matin"
    ),
    
    Traitement(
        nomTraitement: "Grippe",
        imageTraitement: "cross.vial.fill",
        traitementName: "Ibuprofène 200 mg",
        nombreDose: 1,
        momentPrise: "Au cours du repas",
        frequence: "2 fois par jour",
        momentJournee: "matin"
    ),
    
    Traitement(
        nomTraitement: "Grippe",
        imageTraitement: "cross.vial.fill",
        traitementName: "Amoxicilline",
        nombreDose: 1,
        momentPrise: "À jeun",
        frequence: "3 fois par jour",
        momentJournee: "matin"
    ),
    
    Traitement(
        nomTraitement: "Grippe",
        imageTraitement: "pills.fill",
        traitementName: "Vitamine C",
        nombreDose: 1,
        momentPrise: "Après repas",
        frequence: "1 fois par jour",
        momentJournee: "matin"
    ),
    
    Traitement(
        nomTraitement: "Grippe",
        imageTraitement: "pills.fill",
        traitementName: "Oméga 3",
        nombreDose: 2,
        momentPrise: "Au cours du repas",
        frequence: "1 fois par jour",
        momentJournee: "matin"
    )
]

