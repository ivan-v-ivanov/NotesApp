//
//  NoteTableView.swift
//  NotesApp2
//
//  Created by Ivan Ivanov on 21.02.2023.
//

import UIKit
import CoreData

var notesList = [Note]()

class NoteTableView: UITableViewController {
    
    var firstStart = true
    
    override func viewDidLoad() {
        if (firstStart){
            firstStart = false
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
            catch {
                print("Delete Error")
            }
            
            
            notesList.remove(at: indexPath.row)
            tableView.reloadData()
        })
        
        actionDelete.image = UIImage(systemName: "trash")

        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}
