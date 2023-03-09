// Note Class
// Note will Save and Load with Core Data
//
// id - note id (int)
// title - title of note (string)
// content - main text of note (string)
// storedImage - choosed image from gallery (binary)
//

import CoreData

@objc(Note)
class Note: NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var content: String!
    @NSManaged var storedImage: Data!
}
