//
//  Profile.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit

class Profile: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name, about, image
    }
    
    var image: UIImage?
    var name: String
    var about: String
    
    init(name: String, about: String, image: UIImage) {
        self.name = name
        self.about = about
        self.image = image
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(about, forKey: .about)
        
        var imageData: Data? = nil
        if let image = image {
            imageData = UIImagePNGRepresentation(image)
        }
        try container.encode(imageData, forKey: .image)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        about = try container.decode(String.self, forKey: .about)
        
        let imageData = try container.decode(Data.self, forKey: .image)
        image = UIImage(data: imageData)
    }
}
