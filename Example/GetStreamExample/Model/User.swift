//
//  User.swift
//  GetStreamExample
//
//  Created by Alexey Bukhtin on 14/12/2018.
//  Copyright © 2018 Alexey Bukhtin. All rights reserved.
//

import Foundation
import GetStream

final class User: GetStream.User {
    private enum CodingKeys: String, CodingKey {
        case name
    }
    
    var name: String
    
    init(id: String, name: String) {
        self.name = name
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: DataCodingKeys.self)
        let container = try dataContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        name = try container.decode(String.self, forKey: .name)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var dataContainer = encoder.container(keyedBy: DataCodingKeys.self)
        var container = dataContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try container.encode(name, forKey: .name)
        try super.encode(to: encoder)
    }
}
