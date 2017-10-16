//
//  Profile.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 16.10.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit

class Profile: NSObject, NSCoding {
    
    var image: UIImage
    var name: String
    var about: String
    
    init(name: String, about: String, image: UIImage) {
        self.name = name
        self.about = about
        self.image = image
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let imageData = aDecoder.decodeObject(forKey: imageKey) as? Data,
            let name = aDecoder.decodeObject(forKey: nameKey) as? String,
            let about = aDecoder.decodeObject(forKey: aboutKey) as? String,
            let image = UIImage(data: imageData) else {
                return nil
        }
        
        self.init(name: name, about: about, image: image)
    }
    
    func encode(with aCoder: NSCoder) {
        let imageData = UIImagePNGRepresentation(image)
        aCoder.encode(imageData, forKey: imageKey)
        
        aCoder.encode(self.name, forKey: nameKey)
        aCoder.encode(self.about, forKey: aboutKey)
    }
}

private let imageKey = "imageData"
private let nameKey = "name"
private let aboutKey = "about"
