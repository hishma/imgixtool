//
//  AltAttribute.swift
//  ImgixToolKit
//
//  Created by Jeff Johnston on 6/6/18.
//

import Foundation

public struct AltAttribute: ImgAttribute {
    let imageFile: ImageFile
    
    public init(imageFile: ImageFile) {
        self.imageFile = imageFile
    }
    
    public var attribute: String? {
        guard let caption = imageFile.caption else { return nil }
        return "alt=\"" + caption + "\""
    }
}
