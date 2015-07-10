//
//  Animal.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

@objc
class SettingTab {
    
    let title: String
    let creator: String
    let image: UIImage?
    
    init(title: String, creator: String, image: UIImage?) {
        self.title = title
        self.creator = creator
        self.image = image
    }
    
    class func allDogs() -> Array<SettingTab> {
        return [ SettingTab(title: "White Dog Portrait", creator: "photostock", image: UIImage(named: "ID-10034505.jpg")),
            SettingTab(title: "Black Labrador Retriever", creator: "Michal Marcol", image: UIImage(named: "ID-1009881.jpg"))]
    }
}