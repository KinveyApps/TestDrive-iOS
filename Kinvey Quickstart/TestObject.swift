//
//  TestObject.swift
//  Kinvey Test Drive
//
//  Created by Victor Hugo on 2017-02-27.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey

@objc
class TestObject: Entity {
    
    dynamic var name: String?
    
    override static func collectionName() -> String {
        return "testObjects"
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        name <- ("name", map["name"])
    }
    
}
