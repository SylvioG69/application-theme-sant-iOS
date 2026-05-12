//
//  AjoutTraitementView.swift
//
//
//  Created by appreant98 on 30/04/2026.
//

import SwiftUI

struct AjoutTraitementView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var traitements: [Traitement]
    
    @State private var selectedIcon = "pills.fill"
    @State private var nomTraitement = ""
    @State private var nom = ""
    @State private var dose = 1
    @State private var moment = "Après repas"
    @State private var horaire = Date()
    @State private var frequence = "Jamais"
    @State private var showFrequencePicker = false
    @State private var momentJournee = "Matin"
    
    let moments = ["Avant repas", "Après repas", "À jeun"]
    
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
    
    let momentsJournee = [
        "Matin",
        "Midi",
        "Soir"
    ]
    
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Nom Traitement
                    VStack(alignment: .leading) {
                        Text("Nom du traitement")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("colorTexte"))
                        TextField("Nom du traitement", text: $nomTraitement)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }.padding(.bottom,5)
                    
                    VStack(alignment: .leading){
                        Text("Forme")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color("colorTexte"))
                        
                        /*Text("Ajout")
                         .font(.title)
                         .bold()*/
                        
                        // Icônes
                        HStack(alignment: .center) {
                            
                            Spacer()
                            iconButton("pills.fill", label: "Comprimé")
                            //iconButton("cross.case.fill", label: "Kit")
                            iconButton("cross.vial.fill", label: "Sirop")
                            iconButton("drop.fill", label: "Crème")
                            Spacer()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGroupedBackground)))
                        
                    }.padding(.bottom,5)
                    
                    
                    
                    
                    
                    
                    // Nom medicament
                    VStack(alignment: .leading) {
                        Text("Nom")
                            .foregroundStyle(Color("colorTexte"))
                            .font(.body)
                            .fontWeight(.semibold)
                        TextField("Nom du médicament", text: $nom)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }.padding(.bottom,5)
                    
                    // Dose
                    VStack(alignment: .leading) {
                        Text("Nombre de dose")
                            .foregroundStyle(Color("colorTexte"))
                            .font(.body)
                            .fontWeight(.semibold)
                        
                        /*Stepper("\(dose)", value: $dose, in: 1...10)
                         .foregroundStyle(.colorTitre.opacity(0.6))
                         .foregroundColor(.black)
                         .foregroundStyle(.colorTitre.opacity(0.6))
                         
                         
                         }.padding(.bottom)*/
                        
                        /*Stepper(value: $dose, in: 1...10) {
                            Text("\(dose)")
                                .foregroundColor(.black)
                            
                        }
                        .labelsHidden()
                        .controlSize(.small)
                        .foregroundStyle(.colorTitre.opacity(0.8))*/
                        HStack(spacing: 8) {
                        Text("\(dose)")
                            .frame(minWidth: 30)

                        Stepper("", value: $dose, in: 1...10)
                            .labelsHidden()
                            .foregroundStyle(.colorTitre.opacity(0.8))
                    }
                        
                    }.padding(.bottom,5)
                    
                    // Moment
                    VStack(alignment: .leading) {
                        Text("Moment de prise")
                            .foregroundStyle(Color("colorTexte"))
                            .font(.body)
                            .fontWeight(.semibold)
                        Picker("", selection: $moment) {
                            ForEach(moments, id: \.self) { m in
                                Text(m)
                                
                                
                            }
                        }
                        .tint(.black)
                        
                        .pickerStyle(.menu)
                        
                        .foregroundStyle(.black)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.colorTitre.opacity(0.1))))
                        
                        .padding(.bottom, 5)
                        
                    }
                    //.padding()
                    
                    // Fréquence
                    /*VStack(alignment: .leading) {
                     Text("Fréquence")
                     .font(.body)
                     .fontWeight(.semibold)
                     Picker("Fréquence", selection: $frequence) {
                     ForEach(frequences, id: \.self) { frequence in
                     Text(frequence)
                     }
                     }
                     .pickerStyle(.wheel)
                     }
                     */
                    /*VStack(alignment: .leading) {
                     Text("Fréquence")
                     .font(.body)
                     .fontWeight(.semibold)
                     Button {
                     showFrequencePicker = true
                     } label: {
                     HStack {
                     Text("Répéter")
                     Spacer()
                     Text(frequence)
                     .foregroundColor(.gray)
                     }
                     .padding()
                     .background(Color.gray.opacity(0.1))
                     .cornerRadius(10)
                     }
                     
                     }
                     .sheet(isPresented: $showFrequencePicker) {
                     FrequencePickerSheet(frequence: $frequence)
                     .presentationDetents([.medium])
                     .presentationDragIndicator(.visible)
                     }
                     .padding(.bottom)
                     */
                    
                    // freqquence v2
                    VStack(alignment: .leading) {
                        Text("Frequence")
                            .foregroundStyle(Color("colorTexte"))
                            .font(.body)
                            .fontWeight(.semibold)
                        Picker("", selection: $frequence) {
                            ForEach(frequences, id: \.self) { m in
                                Text(m)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.black)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.colorTitre.opacity(0.1))))
                        
                        .padding(.bottom,5)
                        
                    }
                    
                    // Moment de la journée
                    VStack(alignment: .leading) {
                        Text("Moment de la journée")
                            .font(.body)
                            .fontWeight(.semibold)
                        Picker("", selection: $momentJournee) {
                            ForEach(momentsJournee, id: \.self) { m in
                                Text(m)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.black)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.colorTitre.opacity(0.1))))
                        
                        .padding(.bottom, 5)
                        
                    }
                        //.foregroundStyle(.colorTitre.opacity(0.8))
                    
                    Spacer()
                    
                    Button {
                        let newTraitement = Traitement(
                            nomTraitement: nomTraitement,
                            imageTraitement: selectedIcon,
                            traitementName: nom,
                            nombreDose: dose,
                            momentPrise: moment,
                            frequence: frequence,
                            momentJournee: momentJournee
                        )

                        traitements.append(newTraitement)

                        // reset uniquement le médicament
                        nom = ""
                        dose = 1
                        moment = "Après repas"

                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Ajouter un autre médicament")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.colorButton.opacity(0.15))
                        .foregroundColor(Color.colorButton)
                        .cornerRadius(16)
                    }
                    Button {
                        let newTraitement = Traitement(
                            nomTraitement: nomTraitement,
                            imageTraitement: selectedIcon,
                            traitementName: nom,
                            nombreDose: dose,
                            momentPrise: moment,
                            frequence: frequence,
                            momentJournee: momentJournee
                        )

                        traitements.append(newTraitement)
                        dismiss()
                    }
                    label: {
                        Text("Terminer")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.colorButton)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .background(Color(.systemGroupedBackground))
                
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Ajouter le traitement")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
        
    
    
    
    func iconButton(_ name: String, label: String) -> some View {
        Button {
            selectedIcon = name
        } label: {
            VStack(spacing: 0) {
                Image(systemName: name)
                    .font(.title2)
                    //.padding(.horizontal)
                
                Text(label)
                    .font(.system(size: 14))
            }
            
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(
                RoundedRectangle(cornerRadius: 14)
                
                               .fill(
                                   selectedIcon == name
                                   ? Color.colorTitre.opacity(0.6)
                                   : Color.colorlist.opacity(0.5)
                               )
            )
            .foregroundColor(
                selectedIcon == name ? .white : .primary
            )
            .cornerRadius(10)
        }
    }
}

#Preview {
    AjoutTraitementView(traitements: .constant(mockTraitements))
}
