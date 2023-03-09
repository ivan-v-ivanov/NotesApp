//
// View controller of Note Content
//
// Load Note Content from Core Data
// Save Note Content to Core Data
// Choose Image from Gallery
//
// Buttons:
// - Load Image Button
// - Save Button (with content existence check)
//
// Additional functionality:
// - Empty Note Save Alert Notification
//

import UIKit
import CoreData

class NoteDetailViewController: UIViewController {

    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteContent: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedNote : Note? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteContent.font = UIFont.systemFont(ofSize: 18) // note content text size
        
        // MARK: - Load Note Content if Exists
        if selectedNote != nil {
            noteTitle.text = selectedNote?.title
            noteContent.text = selectedNote?.content
            if selectedNote?.storedImage != nil{        // load image if exists
                imageView.image = UIImage(data: (selectedNote?.storedImage)!)
            }
            else {
                imageView.image = nil
            }
        }
    }
    // MARK: - Load Image Button
    @IBAction func loadImage(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    // MARK: - Save Note Button
    @IBAction func saveNote(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if selectedNote == nil{
            
            // check if note content exists
            // remove all whitespaces in title and content
            let checkTitle = noteTitle.text!.removeWhitespaces()
            let checkContent = noteContent.text!.removeWhitespaces()
            
            // if note has a title or content, we should save it
            if checkTitle != "" || checkContent != ""  {
                saveNoteToCoreData(context)
            }
            // if there is no title or content - call a note save notification
            else{
                noteSaveAlert()
            }
        }
        else{
            fetchNoteFromCoreData(context)
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

extension NoteDetailViewController{
    // MARK: - Save Note to Core Data
    func saveNoteToCoreData(_ context: NSManagedObjectContext){
        do {
            let entity = NSEntityDescription.entity(forEntityName: "Note",
                                                    in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            newNote.id = notesList.count as NSNumber
            newNote.title = noteTitle.text
            newNote.content = noteContent.text
            
            if imageView.image != nil{
                let imageData = imageView.image?.pngData()
                newNote.storedImage = imageData
            }
    
            try context.save()
            notesList.append(newNote)
            navigationController?.popViewController(animated: true)
        }
        catch let error as NSError{
            print("Save Error. \(error), \(error.userInfo)")
        }
    }

    // MARK: - Fetch Note from Core Data
    func fetchNoteFromCoreData(_ context: NSManagedObjectContext){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results{
                let note = result as! Note
                if note == selectedNote {
                    note.title = noteTitle.text
                    note.content = noteContent.text
                    let imageData = imageView.image?.pngData()
                    note.storedImage = imageData
                    
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        }
        catch let error as NSError{
            print("Fetch Error. \(error), \(error.userInfo)")
        }
    }
}


// MARK: - Gallery Image Picker
extension NoteDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            imageView.image = image
            
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
     
}
