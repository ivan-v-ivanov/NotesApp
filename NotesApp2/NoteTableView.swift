//
// View controller of Table of Notes
//
// Show All Saved Notes in the Table
// Load Notes Data from Core Data
//
// Functionality:
// - Add New Note Button
// - Change Note Content
// - Delete Note by Slide
//


import UIKit
import CoreData

var notesList = [Note]()

class NoteTableView: UITableViewController {
    
    var firstStart = true // check for fetching
    
    override func viewDidLoad() {
        
        if firstStart {
            firstStart = false
            fetchNoteForTable() // fetch notes from core data
        }
        
        if firstTimeAppLaunch() {     // check if the application has been launched before
            deleteAllCoreData("Note")
            createFirstNote()         // if not, we must create the first note
        }
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCellID",
                                                     for: indexPath) as! NoteCell
        let note: Note!
        note = notesList[indexPath.row]
        noteCell.titleLabel.text = note.title
        noteCell.contentLabel.text = note.content
        
        return noteCell
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return notesList.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editNote"){
            let indexPath = tableView.indexPathForSelectedRow!
            let noteDetail = segue.destination as? NoteDetailViewController
            let selectedNote: Note!
            selectedNote = notesList[indexPath.row]
            noteDetail!.selectedNote = selectedNote
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: - Fetch Note Data with Core Data
extension NoteTableView{
    func fetchNoteForTable(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results{
                let note = result as! Note
                notesList.append(note)
            }
        }
        catch{
            print("Fetch Error")
        }
    }
}

// MARK: - Create Note at App First Start
extension NoteTableView{
    func createFirstNote() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        do {
            let entity = NSEntityDescription.entity(forEntityName: "Note",
                                                    in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            newNote.id = notesList.count as NSNumber
            newNote.title = StartNote().title
            newNote.content = StartNote().content
            try context.save()
            notesList.append(newNote)
            navigationController?.popViewController(animated: true)
        }
        catch let error as NSError{
            print("First Note Save Error. \(error), \(error.userInfo)")
        }
    }
}

// MARK: - Additional Functions
// Delete Note; Delete Core Data; Check App First Start

extension NoteTableView{
    override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {

        let actionDelete = UIContextualAction(style: .destructive,
                                              title: "Удалить",
                                              handler: {_,_,_ in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            context.delete(notesList[indexPath.row])
            
            do {
                try context.save()
            }
            catch let error as NSError{
                print("Delete Error. \(error), \(error.userInfo)")
            }
            
            notesList.remove(at: indexPath.row)
            tableView.reloadData()
        })
        
        actionDelete.image = UIImage(systemName: "trash")

        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
    
    func deleteAllCoreData(_ entity:String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error as NSError{
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    func firstTimeAppLaunch() -> Bool{
            let defaults = UserDefaults.standard
            
            if defaults.bool(forKey: "isAppAlreadyLaunchedOnce"){
                print("App already launched")
                return false
            }else{
                defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
                print("App launched first time")
                return true
            }
        }
}
