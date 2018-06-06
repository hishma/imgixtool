import Foundation
import Utility
import ImgixToolKit

/*
/// Errors which may be encountered when running argument parser.
public enum ImgxToolError: Swift.Error {
    
    /// An unknown option is encountered.
    case unknownOption(String)
    
    /// The value of an argument is invalid.
    case invalidValue(argument: String, error: ArgumentConversionError)
    
    /// Expected a value from the option.
    case expectedValue(option: String)
    
    /// An unexpected positional argument encountered.
    case unexpectedArgument(String)
    
    /// Expected these positional arguments but not found.
    case expectedArguments(ArgumentParser, [String])
}

extension ArgumentParserError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknownOption(let option):
            return "unknown option \(option); use --help to list available options"
        case .invalidValue(let argument, let error):
            return "\(error) for argument \(argument); use --help to print usage"
        case .expectedValue(let option):
            return "option \(option) requires a value; provide a value using '\(option) <value>' or '\(option)=<value>'"
        case .unexpectedArgument(let argument):
            return "unexpected argument \(argument); use --help to list available arguments"
        case .expectedArguments(_, let arguments):
            return "expected arguments: \(arguments.joined(separator: ", "))"
        }
    }
}
 */


// The first argument is always the executable, drop it
let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())

let parser = ArgumentParser(usage: "<options>", overview: "This is what this tool is for")
//let number: OptionArgument<Int> = parser.add(option: "--number", shortName: "-n", kind: Int.self, usage: "A number to compute")
//let uppercased: OptionArgument<Bool> = parser.add(option: "--uppercased", kind: Bool.self)

let widthArg: OptionArgument<Int> = parser.add(option: "--width", shortName: "-w", kind: Int.self, usage: "Width")
let fileArg: PositionalArgument<PathArgument> = parser.add(positional: "file", kind: PathArgument.self, optional: false, usage: "Path to the image file", completion: .filename)
let srcset: OptionArgument<Bool> = parser.add(option: "--srcset", shortName: "-s", kind: Bool.self, usage: "Include the `srcset` attribute.")

func processArguments(arguments: ArgumentParser.Result) throws -> ImgElement {
    
    guard let sourceUrl = URL(string: "https://svbeowulf.imgix.net") else { fatalError() }

    guard let path = arguments.get(fileArg)?.path.asString else {
        throw ArgumentParserError.invalidValue(argument: "file", error: ArgumentConversionError.custom("Invalid file path."))
    }
    
    let wantsSrcset = arguments.get(srcset) ?? false
    let type: ImgElementType = wantsSrcset ? .srcset : .src
    
    
    let imgTag = try ImgElement(sourceUrl: sourceUrl, path: path, type: type, width: arguments.get(widthArg))
    return imgTag
}

do {
    let parsedArguments = try parser.parse(arguments)
    let imgTag = try processArguments(arguments: parsedArguments)
    
    if let element = imgTag.element {
        print(element)
    }
    
}
catch let error as ArgumentParserError {
    print(error.description)
}
catch let error as ImageFileError {
    print(error.description)
}
catch let error {
    print(error.localizedDescription)
}
