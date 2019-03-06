//
//  Petition.swift
//  Whitehouse Petitions
//
//  Created by Michele Galvagno on 06/03/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
