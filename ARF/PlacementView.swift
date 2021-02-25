//
//  PlacementView.swift
//  ARF
//
//  Created by William Moten on 2/24/21.
//

import SwiftUI

struct PlacementView: View {
    // This is the View containing a check or X for placing the item in AR space
    @EnvironmentObject var placementSettings : PlacementSettings
    
    var body: some View {
        HStack {
            
            Spacer()
            
            PlacementButton(systemIconName: "xmark.circle.fill"){
                print("cancel placement button pressed.")
                self.placementSettings.selectedModel = nil
                
            }
            
            Spacer()
            
            PlacementButton(systemIconName: "checkmark.circle.fill"){
                print("confirm placement button pressed.")
                
                self.placementSettings.confirmedModel = self.placementSettings.selectedModel
                
                self.placementSettings.selectedModel = nil
            }
            
            Spacer()
        }
        .padding(.bottom, 30)
    }
}

struct PlacementButton: View {
    // Reusable button for above view
    let systemIconName: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action:{
            self.action()
        }){
            Image(systemName: systemIconName)
                .font(.system(size: 50, weight: .light, design: .default))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 75, height: 75)
    }
}
