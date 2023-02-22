
import UIKit
import CoreData

class NoteDetailViewController: UIViewController {

    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    
    var selectedNote : Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteContent.font = UIFont.systemFont(ofSize: 20)
//        noteContent.allowsEditingTextAttributes = true
//        noteContent.isSelectable = true
//        noteContent.isEditable = false
//        noteContent.dataDetectorTypes = UIDataDetectorTypes.link
        
        if selectedNote != nil {
            noteTitle.text = selectedNote?.title
            noteContent.text = selectedNote?.content
        }
    }

// MARK: - Save Note
    @IBAction func saveNote(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if selectedNote == nil{
            
            let checkTitle = noteTitle.text!.removeWhitespaces()
            let checkContent = noteContent.text!.removeWhitespaces()
            
            if checkTitle != "" || checkContent != ""  {
                do {
                    let entity = NSEntityDescription.entity(forEntityName: "Note",
                                                            in: context)
                    let newNote = Note(entity: entity!, insertInto: context)
                    newNote.id = notesList.count as NSNumber
                    newNote.title = noteTitle.text
                    newNote.content = noteContent.text
            
                    try context.save()
                    notesList.append(newNote)
                    navigationController?.popViewController(animated: true)
                }
                catch {
                    print("Save Error")
                }
            }
            else{
                noteSaveAlert()
            }
        }
        else{
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results{
                    let note = result as! Note
                    if note == selectedNote {
                        note.title = noteTitle.text
                        note.content = noteContent.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            catch{
                print("Fetch Error")
            }
        }
    }
// MARK: - Note Save Alert
    private func noteSaveAlert(){
        let alertController = UIAlertController(title: "Пустая заметка",
                                                message: "Введите название или текст заметки",
                                                preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "OK",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelButton)
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
}

