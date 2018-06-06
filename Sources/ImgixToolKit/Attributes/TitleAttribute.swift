//
//  TitleAttribute.swift
//  ImgixToolKit
//
//  Created by Jeff Johnston on 6/6/18.
//

import Foundation

public struct TitleAttribute: ImgAttribute {
    let imageFile: ImageFile
    
    public init(imageFile: ImageFile) {
        self.imageFile = imageFile
    }
    
    public var attribute: String? {
        guard let title = imageFile.title else { return nil }
        return "title=\"" + title + "\""
    }
}
