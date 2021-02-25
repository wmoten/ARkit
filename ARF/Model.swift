//
//  Model.swift
//  ARF
//
//  Created by William Moten on 2/22/21.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable{
    case toys
    case decor
    case misc
    
    var label: String {
        get {
            switch self{
            case .toys:
                return "Toys"
            case .decor:
                return "Decor"
            case .misc:
                return "Misc"
            }
        }
    }
}


class Model{
    var name: String
    var category: ModelCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0){
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    
    //async load modelEntity when needed
    func asyncLoadModelEntity() {
        let filename = self.name + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion : {loadCompletion in
                
                switch loadCompletion{
                case .failure(let error):
                    print("Unable to load modelEntity for \(filename).Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: {modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                print("modelEntity for \(self.name) has been loaded")
            })
    }
}

struct Models{
    var all: [Model] = []
    
    init(){
        // setup manually all models
        let chairSwan = Model(name:"chair_swan", category: .decor, scaleCompensation: 1.0)
        let gramophone = Model(name:"gramophone", category: .decor, scaleCompensation: 1.0)
        let tvRetro = Model(name:"tv_retro", category: .decor, scaleCompensation: 1.0)
        let toyCar = Model(name:"toy_car", category: .toys, scaleCompensation: 1.0)
        let toyDrummer = Model(name:"toy_drummer", category: .toys, scaleCompensation: 1.0)
        let toyRobotVintage = Model(name:"toy_robot_vintage", category: .toys, scaleCompensation: 1.0)
        let trowel = Model(name:"trowel", category: .misc, scaleCompensation: 1.0)
        let teapot = Model(name:"teapot", category: .misc, scaleCompensation: 1.0)

        self.all += [chairSwan, gramophone, tvRetro, toyCar, toyDrummer, toyRobotVintage, trowel, teapot]
        
    }
    func get(category: ModelCategory) -> [Model] {
        return all.filter( {$0.category == category} )
    }
}

