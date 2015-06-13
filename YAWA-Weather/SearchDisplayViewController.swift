//
//  SearchDisplayViewController.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 12/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import UIKit

class SearchDisplayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

	var tableData = [Location]()
	let searchController = UISearchController(searchResultsController: nil)
	
	@IBOutlet weak var searchResultsTable: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Search"
		searchController.searchResultsUpdater = self
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.sizeToFit()
		searchResultsTable.tableHeaderView = searchController.searchBar
		
		searchResultsTable.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func search(sender: UIBarButtonItem) {
	}
	
	@IBAction func cancelSearch(sender: AnyObject) {
		
		if searchController.searchBar.isFirstResponder() {
			searchController.searchBar.resignFirstResponder()
		}
		tableData = []
		navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
			
		})
	}
	
 // MARK: - Table view data source
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return tableData.count
	}
	
	 func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		var section = indexPath.section
		var row = indexPath.row
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"addCategoryCell")
		cell.textLabel?.textAlignment = NSTextAlignment.Left
		cell.textLabel?.textColor = UIColor.blackColor()
		cell.textLabel?.font = UIFont(name: "Open Sans", size: 16.0)!
		cell.detailTextLabel?.font = UIFont(name: "OpenSans-Semibold", size: 10.0)!
		let location = tableData[indexPath.row]
		
		var locality = location.locality
		if (count(locality) < 1) {
			locality = location.adminArea
		}
		cell.textLabel?.text = "\(locality)"
	
		cell.detailTextLabel?.text = "\(location.county)"
		return cell
	}
	
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		tableData = []
		searchResultsTable.reloadData()
	
	}
	
	//MARK: - UISearchControllerDelegate
	
	func willDismissSearchController(searchController: UISearchController) {
		tableData = []
	}

	func didPresentSearchController(searchController: UISearchController) {
		searchController.searchBar.becomeFirstResponder()
	}
	//MARK: UISearchResultsUpdater delegate
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		
		let locationManager = LocationManager.init()
		
		let searchTerms = searchController.searchBar.text
		if ( count(searchTerms) > 1) {
			
			locationManager.searchForLocationWithName(searchTerms, completionHandler: { (searchResults, error) -> () in
				
				self.tableData.removeAll(keepCapacity: false)
				self.tableData = searchResults as [Location]
				self.searchResultsTable.reloadData()
			})
		}
	}
	
}


