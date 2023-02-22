//
//  Note.swift
//  NotesApp2
//
//  Created by Ivan Ivanov on 21.02.2023.
//

import CoreData

@objc(Note)
class Note: NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var content: String!
    @NSManaged var deletedDate: Date!
}
