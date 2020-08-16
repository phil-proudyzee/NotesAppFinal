//
//  ViewController.swift
//  Notes
//
//  Created by Philip Lagud on 3/16/20.
//  All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
  
    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!

    //var models: [(title: String, note: String)] = []
    // creating an array and making an instance of the notecomponent struct
    var models = [notescomponent]()
    var filterednote = [notescomponent]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assigning table to its delegate and datasource
        table.delegate = self
        table.dataSource = self
        title = "Notes"
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        table.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = UIColor.black
    }
    
    // executes code if the user taps the "+" buttpn

    @IBAction func didTapNewNote() {
        //if the user taps "new notes" or the + button, then the user is sent to the EntryViewController screen. let vc storyboard?.instantiateviewcontroller means calling the data from another class.
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else {
            return
        }
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        // once the user presses the save button, entryviewcontroller will send noteTitle and note data into the main screen.
        vc.completion = { noteTitle, note in
            // this code will send user back to the root view controller
            self.navigationController?.popToRootViewController(animated: true)
            // creating a constructor that assigns the data that the user has inputted into the memory.
            let new = notescomponent(title: noteTitle, note: note)
            // this particular code adds the data the user has entered into the memory.
            self.models.append(new)
            
            //once the table is not empty anymore, the label that reminds the user that there are no notes in the memory will be removed from the screen, hence "itsHidden = true".
            self.label.isHidden = true
            self.table.isHidden = false
            self.table.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
            
    }
    
    @IBAction func didSortArray() {
        // sortedString = string.sort { (firstObject < secondObject)
        // sort string using the built in "Comparable" protocol. $0 <- firstobject, $1 <- secondobject.
        self.models.sort(by: {$0.title < $1.title})
        self.table.reloadData()
    }

    // Table

    // states how many data will be displayed depending whether the user is on "search" mode or "normal" mode
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            // if the search controller is active, present the ammount filtered notes.
            return filterednote.count
        }   // otherwise, present the number of the notes "models"
        return models.count
    }
    // states what data will be displayed on screen.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // filterednote
        // if searchcontroller is active, display filtered notes, else display notes content
        let notescontents: notescomponent
        if searchController.isActive && searchController.searchBar.text != "" {
            print(filterednote)
            notescontents = filterednote[indexPath.row]
        } else {
            notescontents = models[indexPath.row]
        }
        // models[indexPath.row].title
        cell.textLabel?.text = notescontents.title
        cell.detailTextLabel?.text = notescontents.note
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        //let model = models[indexPath.row]

        // Show note controller
        // constructor
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? NoteViewController else {
            return
        }
       if searchController.isActive && searchController.searchBar.text != "" {
                  print(filterednote)
                // same as the code executed for cellforrowat and numberofrowsinsection but specifically for what data will be presented to you when you a tap a specific cell.
                  vc.noteTitle = filterednote[indexPath.row].title
                  vc.note = filterednote[indexPath.row].note
              } else {
                  vc.noteTitle = models[indexPath.row].title
                  vc.note = models[indexPath.row].note
              }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Note"
        //vc.noteTitle = models[indexPath.row].title
        //vc.note = models[indexPath.row].note
        navigationController?.pushViewController(vc, animated: true)
    }
    func updateSearchResults(for searchController: UISearchController) {
        filternotescontent(for: searchController.searchBar.text ?? "")
      }
    // this method filters notes content using .filter(:) instance method.
    private func filternotescontent(for searchTexts: String) {
      filterednote = models.filter { notestitle in
        return
          notestitle.title.lowercased().contains(searchTexts.lowercased())
      }
      table.reloadData()
    }
    
    // function that deletes specific cells on the table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            models.remove(at: indexPath.row)
            table.reloadData()
        }
    }

}


struct notescomponent {
    var title:String
    var note:String
}

