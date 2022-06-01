//
//  SourceEditorCommand.swift
//  SwiftMockGen
//
//  Created by Yusuf Özgül on 31.05.2022.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        do {
            let spy = try SpyGenerator(buffer: invocation.buffer).generate(source: invocation.buffer.lines.componentsJoined(by: "")).components(separatedBy: "\n")
            invocation.buffer.lines.removeAllObjects()
            invocation.buffer.lines.addObjects(from: spy)
            completionHandler(nil)
        } catch let error as GenError {
            completionHandler(error.error)
        } catch {
            completionHandler(error)
        }
    }
    
}
