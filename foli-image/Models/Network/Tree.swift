//
//  Tree.swift
//  foli-image
//
//  Created by Jeremy Ben-Meir on 7/31/19.
//  Copyright © 2019 Jeremy Ben-Meir. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AssetsLibrary
import MapKit
import CoreLocation

struct Tree: Codable {
    var stringData: String
    var lat: Float
    var longt: Float
}

struct GetTreeResponse: Codable {
    var data: Tree
}

struct GetTreesResponse: Codable {
    var data: [Tree]
}

//class Tree {
//    
//    var image: UIImage
//    var location: CLLocation?
//    
//    init(inputImage: UIImage, inputLocation: CLLocation?) {
//        image = inputImage
//        location = inputLocation
//    }
//}
