//
//  ImageFile.swift
//  ImgixToolKit
//
//  Created by Jeff Johnston on 6/6/18.
//

import Foundation
import ImageIO

public enum ImageFileError: Error {
    case invalidTypeIdentifier
    case invalidImageSource(path: String)
    case invalidImageProperties(path: String)
    case unknown
}

extension ImageFileError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidTypeIdentifier:
            return "invalid type identifier."
        case .invalidImageSource(let path):
            return "\(path) is not a valid image file."
        case .invalidImageProperties(let path):
            return "\(path) has no image properties."
        case .unknown:
            return "an unkown error has occured."
        }
    }
}

public struct ImageFile {
    public let path: String
    public let url: URL
    public let properties: NSDictionary
    public let uti: String?
    
    public init(path: String) throws {
        self.path = path
        let fileUrl = URL.init(fileURLWithPath: path)
        self.url = fileUrl

        guard let imageSource = CGImageSourceCreateWithURL(fileUrl as CFURL, nil) else {
            throw ImageFileError.invalidImageSource(path: path)
        }
        
        self.uti = CGImageSourceGetType(imageSource) as String?
        
        guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as NSDictionary? else {
            throw ImageFileError.invalidImageProperties(path: path)
        }

        self.properties = imageProperties
    }

    /* The number of pixels in the x- and y-dimensions. The value of these keys
     * is a CFNumberRef. */
    public var height: Int? {
        return properties[kCGImagePropertyPixelHeight] as? Int
    }
    
    public var width: Int? {
        return properties[kCGImagePropertyPixelWidth] as? Int
    }
    
    /* The DPI in the x- and y-dimensions, if known. If present, the value of
     * these keys is a CFNumberRef. */
    public var dpiHeight: Int? {
        return properties[kCGImagePropertyDPIHeight] as? Int
    }
    
    public var dpiWidth: Int? {
        return properties[kCGImagePropertyDPIWidth] as? Int
    }
    
    /* The number of bits in each color sample of each pixel */
    public var bitDepth: Int? {
        return properties[kCGImagePropertyDepth] as? Int
    }
    
    /* The intended display orientation of the image. If present, the value
     * of this key is a CFNumberRef with the same value as defined by the
     * TIFF and Exif specifications.  That is:
     *   1  =  0th row is at the top, and 0th column is on the left.
     *   2  =  0th row is at the top, and 0th column is on the right.
     *   3  =  0th row is at the bottom, and 0th column is on the right.
     *   4  =  0th row is at the bottom, and 0th column is on the left.
     *   5  =  0th row is on the left, and 0th column is the top.
     *   6  =  0th row is on the right, and 0th column is the top.
     *   7  =  0th row is on the right, and 0th column is the bottom.
     *   8  =  0th row is on the left, and 0th column is the bottom.
     * If not present, a value of 1 is assumed. */
    public var orientation: Int {
        //TODO: humanize this
        return properties[kCGImagePropertyOrientation] as? Int ?? 1
    }
    
    /* The value of this key is kCFBooleanTrue if the image contains floating-
     * point pixel samples */
    public var isFloat: Bool? {
        return properties[kCGImagePropertyIsFloat] as? Bool
    }
    
    /* The value of this key is kCFBooleanTrue if the image contains indexed
     * (a.k.a. paletted) pixel samples */
    public var isIndexed: Bool? {
        return properties[kCGImagePropertyIsFloat] as? Bool
    }
    
    /* The value of this key is kCFBooleanTrue if the image contains an alpha
     * (a.k.a. coverage) channel */
    public var hasAlpha: Bool? {
        return properties[kCGImagePropertyHasAlpha] as? Bool
    }
    
    /* The color model of the image such as "RGB", "CMYK", "Gray", or "Lab".
     * The value of this key is CFStringRef. */
    public var colorModel: String? {
        return properties[kCGImagePropertyColorModel] as? String
    }
    
    /* The name of the optional ICC profile embedded in the image, if known.
     * If present, the value of this key is a CFStringRef. */
    public var colorProfile: String? {
        return properties[kCGImagePropertyProfileName] as? String
    }
    
    // MARK: -
    
    public var tiff: TIFF? {
        guard let tiffProperties = properties[kCGImagePropertyTIFFDictionary] as? NSDictionary else {
            return nil
        }
        return TIFF(properties: tiffProperties)
    }
    
    public var gfif: NSDictionary? {
        return properties[kCGImagePropertyGIFDictionary] as? NSDictionary
    }
    
    public var jfif: NSDictionary? {
        return properties[kCGImagePropertyJFIFDictionary] as? NSDictionary
    }
    
    public var exif: EXIF? {
        guard let exifProperties = properties[kCGImagePropertyExifDictionary] as? NSDictionary else {
            return nil
        }
        return EXIF(properties: exifProperties)
    }
    
    public var png: NSDictionary? {
        return properties[kCGImagePropertyPNGDictionary] as? NSDictionary
    }
    
    public var iptc: IPTC? {
        guard let iptcProperties = properties[kCGImagePropertyIPTCDictionary] as? NSDictionary else {
            return nil
        }
        return IPTC(properties: iptcProperties)
    }
    
    public var raw: NSDictionary? {
        return properties[kCGImagePropertyRawDictionary] as? NSDictionary
    }
    
    public var photoshop8BIM: NSDictionary? {
        return properties[kCGImageProperty8BIMDictionary] as? NSDictionary
    }
    
    public var dng: NSDictionary? {
        return properties[kCGImagePropertyDNGDictionary] as? NSDictionary
    }
    
    // MARK: - URL Properties
    
    public var localizedName: String? {
        return url.localizedName
    }
    
    public var urlTypeIdentifier: String? {
        return url.typeIdentifier
    }
    
    // MARK: - Custom Properties
    
    public var artist: String? {
        var artist: String?
        
        if let bylines = iptc?.byline, !bylines.isEmpty {
            artist = bylines.joined(separator: ", ")
        } else {
            artist = tiff?.artist
        }
        
        return artist
    }
    
    public var byline: String? {
        return artist
    }
    
    public var caption: String? {
        return iptc?.captionAbstract
    }
    
    public var copyright: String? {
        var copyright: String?
        
        if let c = iptc?.copyrightNotice {
            copyright = c
            
            if let terms = iptc?.rightsUsageTerms {
                copyright?.append(" \(terms)")
            }
            
        } else if let c = tiff?.copyright {
            copyright = c
        }
        
        return copyright
    }
    
    public var date: Date? {
        var date: Date?
        
        if let d = iptc?.dateTimeCreated {
            date = d
        } else if let d = iptc?.dateTimeDigitized {
            date = d
        } else if let d = exif?.dateTimeOriginal {
            date = d
        } else if let d = exif?.dateTimeDigitized {
            date = d
        }
        
        return date
    }
    
    public var filename: String {
        return url.lastPathComponent
    }
    
    public var keywords: [String]? {
        return iptc?.keywords
    }
    
    /*
    var name: String {
        var name = url.deletingPathExtension().lastPathComponent
        
        if let delim = fingerprintDelimiter {
            var components = name.components(separatedBy: delim)
            if components.count > 1 {
                components.removeLast()
            }
            name = components.joined()
        }
        
        return name
    }
 */
    
    public var title: String? {
        return iptc?.objectName
    }
    
    public var typeIdentifier: String? {
        return uti
    }
    
    // MARK: -
    
    public var metadata: [String: Any] {
        var metadata = [String: Any]()
        
        metadata["artist"] = artist
        metadata["bitDepth"] = bitDepth
        metadata["caption"] = caption
        metadata["colorModel"] = colorModel
        metadata["colorProfile"] = colorProfile
        metadata["copyright"] = copyright
//        metadata["date"] = date?.jsonValue
        metadata["dpiHeight"] = dpiHeight
        metadata["dpiWidth"] = dpiWidth
        metadata["filename"] = filename
        metadata["hasAlpha"] = hasAlpha
        metadata["headline"] = iptc?.headline
        metadata["height"] = height
        metadata["isFloat"] = isFloat
        metadata["isIndexed"] = isIndexed
        metadata["keywords"] = keywords
//        metadata["name"] = name
        metadata["orientation"] = orientation
        metadata["path"] = path
        metadata["title"] = title
        metadata["url"] = url.absoluteString
        metadata["uti"] = uti
        metadata["width"] = width
        
        return metadata
    }
    
    // MARK: - Hashable
    
    public var hashValue: Int {
        return filename.hashValue
    }
    
    // MARK: - CustomStringConvertible
    
    public var description: String {
        return "ImageFile: metadata: \(metadata)"
    }
    
    // MARK: - CustomDebugStringConvertible
    
    var debugDescription: String {
        return properties.debugDescription
    }
}

// MARK: - Comparable

func == (left: ImageFile, right: ImageFile) -> Bool {
    return left.hashValue == right.hashValue
}

func != (left: ImageFile, right: ImageFile) -> Bool {
    return !(left == right)
}

func < (left: ImageFile, right: ImageFile) -> Bool {
    return left.hashValue < right.hashValue
}

