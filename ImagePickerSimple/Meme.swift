//
//  Meme.swift
//  ImagePickerSimple
//
//  Created by J B on 5/19/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String!
    var bottomText: String!
    var imagePickerView: UIImage!
    var memedImage: UIImage!
    
    init(topText:String!, bottomText:String!, imagePickerView:UIImage!, memedImage:UIImage!) {
        self.topText = topText
        self.bottomText = bottomText
        self.imagePickerView = imagePickerView
        self.memedImage = memedImage
    }
}
