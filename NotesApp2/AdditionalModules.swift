//
//  AdditionalModules.swift
//  NotesApp2
//
//  Created by Ivan Ivanov on 22.02.2023.
//

import Foundation


extension String {
   func replace(string:String, replacement:String) -> String {
       return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
   }
    
   func removeWhitespaces() -> String {
       return self.replace(string: " ", replacement: "")
   }
 }
