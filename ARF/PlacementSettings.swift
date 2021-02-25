//
//  PlacementSettings.swift
//  ARF
//
//  Created by William Moten on 2/22/21.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject{
    
    // this property is set when the user selects a model in BrowseView.
    @Published var selectedModel: Model? {
        willSet(newValue) {
            print("setting selectedModel to \(String(describing: newValue?.name))")
        }
    }
    
    // when the user taps confirm in PlacementView, the value of selectedModel is assigned to confirmed model.
    @Published var confirmedModel: Model? {
        willSet(newValue){
            guard let model = newValue else {
                print("Clearing confirmedModel")
                return
            }
            
            print("Setting confirmed Model to\(model.name)")
        }
    }
}
