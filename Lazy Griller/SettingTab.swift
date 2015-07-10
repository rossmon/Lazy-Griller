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
    let image: UIImage?
    
    init(title: String, image: UIImage?) {
        self.title = title
        self.image = image
    }
    
    class func menuItems() -> Array<SettingTab> {
        return [SettingTab(title: "Temperatures", image: UIImage(named: "Thermometer-30.png")),
            SettingTab(title: "Graphs", image: UIImage(named: "Line Chart-30.png")),SettingTab(title: "Settings", image: UIImage(named: "Settings-30.png"))]
    }
}