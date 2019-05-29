//
//  SearchViewController.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 5/29/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

class SearchViewController: UISearchController {
    typealias Model = [Note]
    
    // MARK: - Properties
    
    private var model = Model()
    private(set) var filteredModel = Model()
    private var noteSearchBar = NoteSearchBar()
    
    // MARK: - Init
    
    init(model: [Note]) {
        super.init(nibName: typeString(SearchViewController.self), bundle: .main)
        self.model = model
        self.searchResultsUpdater = self
        self.hidesNavigationBarDuringPresentation = false
        self.dimsBackgroundDuringPresentation = false
        self.setupSearchBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {

    }
    
    private func setupSearchBar() {
        let searchView = self.noteSearchBar
        searchView.backgroundColor = UIColor.gray
        searchView.barTintColor = UIColor.white
        if let textfield = self.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            self.filteredModel = self.model.filter { note in
                return note.content.lowercased().contains(searchText.lowercased())
            }
        } else {
            self.filteredModel = self.model
        }
    }
}

