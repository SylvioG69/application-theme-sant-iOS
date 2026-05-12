//
//  ApplicationView.swift
//  Sante
//
//  Created by appreant98 on 04/05/2026.
//

import SwiftUI

struct ApplicationView: View {
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(Color.black.opacity(8))
                                .frame(width: 350, height: 70)
                                .padding(.bottom, 8)
            TabView {
                TraitementView()
                    .tabItem {
                        Label ("Traitement", systemImage: "pill")
                            
                    }
                   
                MaPharmacieView()
                    .tabItem { Label( "Ma Pharmacie", systemImage: "cross.case")
                    }
                    
                RecyclageView()
                            .tabItem {
                                Label ("Recyclage", systemImage: "arrow.3.trianglepath")
                            }
                    }
            
            .tint(.colorTitre)
            
        }
       
        
        
        
        }
    
}
#Preview {
    ApplicationView()
}
