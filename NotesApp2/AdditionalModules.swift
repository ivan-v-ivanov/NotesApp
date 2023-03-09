// methods for working with string type
// used in NoteDetailViewController to check existance of Note
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
