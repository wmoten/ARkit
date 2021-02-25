//
//  Model.swift
//  ARF
//
//  Created by William Moten on 2/22/21.
//

import SwiftUI
import RealityKit
import Combine
import UIKit
import Foundation
import SceneKit
import SceneKit.ModelIO

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
    var filename: String
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0){
        self.name = name
        self.category = category
        self.filename = self.name + ".usdz"
        let imgdefault = UIImage(systemName: "photo")!
        let defaulturl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = Bundle.main.url(forResource: name, withExtension: "usdz")
        self.thumbnail = ARQLThumbnailGenerator().thumbnailGen(url: fileURL ?? defaulturl) ?? imgdefault
        self.scaleCompensation = scaleCompensation
    }
    
    //async load modelEntity when needed
    func asyncLoadModelEntity() {
        self.cancellable = ModelEntity.loadModelAsync(named: self.filename)
            .sink(receiveCompletion : {loadCompletion in
                
                switch loadCompletion{
                case .failure(let error):
                    print("Unable to load modelEntity for \(self.filename).Error: \(error.localizedDescription)")
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


class ARQLThumbnailGenerator {
    private let device = MTLCreateSystemDefaultDevice()!
    /// Create a thumbnail image of the asset with the specified URL at the specified
    /// animation time. Supports loading of .scn, .usd, .usdz, .obj, and .abc files,
    /// and other formats supported by ModelIO.
    /// - Parameters:
    ///     - url: The file URL of the asset.
    ///     - size: The size (in points) at which to render the asset.
    ///     - time: The animation time to which the asset should be advanced before snapshotting.
    
    func thumbnailGen(url: URL, time: TimeInterval = 0) -> UIImage? {
//        let filepath = Bundle.main.path(forResource: filename, ofType: "png")!
//        let url = URL(fileURLWithPath: filepath)
        let size = CGSize(width: 275.0, height: 275.0)
        let renderer = SCNRenderer(device: MTLCreateSystemDefaultDevice(), options: [:])
        renderer.autoenablesDefaultLighting = true

        if (url.pathExtension == "scn") {
            let scene = try? SCNScene(url: url, options: nil)
            renderer.scene = scene
        } else {
            let asset = MDLAsset(url: url)
            asset.loadTextures()
            let scene = SCNScene(mdlAsset: asset)
            renderer.scene = scene
        }
        let image = renderer.snapshot(atTime: time, with: size, antialiasingMode: .multisampling4X)
        return image
        
    }

}
