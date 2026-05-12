//
//  FrequencePickerView.swift
//  Sante
//
//  Created by appreant98 on 30/04/2026.
//

import SwiftUI

struct FrequencePickerSheet: View {
    
    @Binding var frequence: String
    @Environment(\.dismiss) var dismiss
    
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
                ForEach(frequences, id: \.self) { f in
                    HStack {
                        Text(f)
                        
                        Spacer()
                        
                        if f == frequence {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        frequence = f
                        dismiss() // ferme le popup après sélection
                    }
                }
            }
            .navigationTitle("Répéter")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
    }
}
