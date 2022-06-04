//
//  SpyGenerator.swift
//  MockGen
//
//  Created by Yusuf Özgül on 29.05.2022.
//

import Foundation
import SwiftFormat
import SwiftFormatConfiguration
import SwiftSemantics
import SwiftSyntax
import SwiftSyntaxParser

public class SpyGenerator {
    private let buffer: XcodeProtocol
    public init(buffer: XcodeProtocol) { self.buffer = buffer }

    public func generate(source: String) throws -> String {
        var spyClasss = Mock()
        let collector = DeclarationCollector()
        let tree = try SyntaxParser.parse(source: source)
        collector.walk(tree)

        guard let classDefiniton = collector.classes.first?.description else { throw GenError.classNameError }

        // Initial
        // Add file header
        for line in source.lines {
            guard line != collector.imports.first?.description && !line.contains(classDefiniton) else { break }
            spyClasss
                .add(line)
                .addNewLine()
        }
        let importSection = collector.imports.map(\.description).joined(separator: "\n")
        if !importSection.isEmpty {
            spyClasss.add(importSection)
            spyClasss.addNewLine()
        }
        spyClasss.addToNewLine("\(classDefiniton) {")

        // Variable
        collector.variables.forEach { variable in
            spyClasss
                .addToNewLine("var invoked\(variable.name.firstUppercased)Setter = false")
                .addToNewLine("var invoked\(variable.name.firstUppercased)SetterCount = 0")
                .addToNewLine("var invoked\(variable.name.firstUppercased): \(variable.typeAnnotation ?? "")?")
                .addToNewLine("var invoked\(variable.name.firstUppercased)List: [\(variable.typeAnnotation ?? "")] = []")
                .addToNewLine("var invoked\(variable.name.firstUppercased)Getter = false")
                .addToNewLine("var invoked\(variable.name.firstUppercased)GetterCount = 0")
                .addToNewLine("var stubbed\(variable.name.firstUppercased): \(variable.typeAnnotation ?? "")!")

            if let defaultValue = DefaultValues(rawValue: variable.typeAnnotation ?? "")?.defaultValue {
                spyClasss.add(" = \(defaultValue)")
            }

            spyClasss
                .addToNewLine("var \(variable.name): \(variable.typeAnnotation ?? "") {")
                .addToNewLine("set {")
                .addToNewLine("invoked\(variable.name.firstUppercased)Setter = true")
                .addToNewLine("invoked\(variable.name.firstUppercased)SetterCount += 1")
                .addToNewLine("invoked\(variable.name.firstUppercased) = newValue")
                .addToNewLine("invoked\(variable.name.firstUppercased)List.append(newValue)")
                .addToNewLine("}")
                .addToNewLine("get {")
                .addToNewLine("invoked\(variable.name.firstUppercased)Getter = true")
                .addToNewLine("invoked\(variable.name.firstUppercased)GetterCount += 1")
                .addToNewLine("return stubbed\(variable.name.firstUppercased)")
                .addToNewLine("}")
                .addToNewLine("}")
            spyClasss.addNewLine()
        }

        // Function
        collector.functions.forEach { function in
            spyClasss
                .addToNewLine("var invoked\(function.identifier.firstUppercased) = false")
                .addToNewLine("var invoked\(function.identifier.firstUppercased)Count = 0")

            // Function parameters
            let parameters = function.signature.input.filter { !$0.isClosure }.map { "\($0.firstName ?? ""): \($0.type ?? "")"}.joined(separator: ", ")
            if !parameters.isEmpty {
                spyClasss
                    .addToNewLine("var invoked\(function.identifier.firstUppercased)Parameters: (\(parameters), Void)?")
                    .addToNewLine("var invoked\(function.identifier.firstUppercased)ParametersList: [(\(parameters), Void)] = []")
            }

            // Closures
            function.signature.input
                .filter { $0.isClosure }
                .forEach { closure in
                    if let closureInputType = closure.closureInputType {
                        spyClasss
                            .addToNewLine("var stubbed\(function.identifier.firstUppercased)\(closure.firstName?.firstUppercased ?? "")Result: (\(closureInputType), Void)?")
                    }
                }

            // Return
            if let output = function.signature.output {
                spyClasss
                    .addToNewLine("var stubbed\(function.identifier.firstUppercased)Result: \(output)!")
            }

            spyClasss
                .addToNewLine("func \(function.identifier)\(function.signature.description) {")
                .addToNewLine("invoked\(function.identifier.firstUppercased) = true")
                .addToNewLine("invoked\(function.identifier.firstUppercased)Count += 1")

            // Function parameters
            let parameterNames = function.signature.input.filter { !$0.isClosure }.map { "\($0.firstName ?? "")"}.joined(separator: ", ")
            if !parameterNames.isEmpty {
                spyClasss
                    .addToNewLine("invoked\(function.identifier.firstUppercased)Parameters = (\(parameterNames), ())")
                    .addToNewLine("invoked\(function.identifier.firstUppercased)ParametersList.append((\(parameterNames), ()))")
            }

            // Closures
            function.signature.input
                .filter { $0.isClosure }
                .forEach { closure in
                    spyClasss
                        .addToNewLine("if let result = stubbed\(function.identifier.firstUppercased)\(closure.firstName?.firstUppercased ?? "")Result {")
                        .addToNewLine("_ = \(closure.firstName ?? "")(result.0)")
                        .addToNewLine("}")
                }

            // Return
            if function.signature.output != nil {
                spyClasss
                    .addToNewLine("return stubbed\(function.identifier.firstUppercased)Result")
            }

            spyClasss
                .addToNewLine("}")
                .addNewLine()
        }

        // End
        spyClasss.addToNewLine("}")

        var configuration: Configuration = .init()

        if buffer.usesTabsForIndentation {
            configuration.indentation = .tabs(buffer.indentationWidth)
        } else {
            configuration.indentation = .spaces(buffer.indentationWidth)
        }
        let formatter = SwiftFormatter(configuration: configuration)

        try formatter.format(source: spyClasss.mockClass,
                             assumingFileURL: nil,
                             to: &spyClasss)

        return spyClasss.mockClass
    }
}
