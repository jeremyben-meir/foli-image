//
//  User.swift
//  Survision
//
//  Created by Jeremy Ben-Meir on 8/17/19.
//  Copyright © 2019 Jeremy Ben-Meir. All rights reserved.
//

import Foundation
import UIKit

struct User: Codable{
    var firstName: String
    var lastName: String
    var email: String
    var id: Int
    var images: [Tree]
}


struct GetUserResponse: Codable {
    var data: User
}

struct CreateUserResponse: Codable {
    var data: User
}
