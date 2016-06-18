//
//  SearchDisplayViewController.swift
//  YAWA-Weather
//
//  Created by edwin bosire on 12/06/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

import UIKit

class SearchDisplayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

	var delegate: LocationSearchDelegate?
	var tableData = [Location]()
	let searchController = UISearchController(searchResultsController: nil)
	
	@IBOutlet weak var searchResultsTable: UITableView!
	@IBOutlet weak var badgeView: UIView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.title = "Search"
		searchController.searchResultsUpdater = self
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.dimsBackgroundDuringPresentation = false
		searchController.searchBar.sizeToFit()
		searchResultsTable.tableHeaderView = searchController.searchBar
		searchResultsTable.tableFooterView = UIView()
		searchResultsTable.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func search(sender: UIBarButtonItem) {
	}
	
	@IBAction func cancelSearch(sender: AnyObject) {
		
		searchController.active = false
		tableData = []
		delegate?.dismissSearchViewController(self)
	}
	
 // MARK: - Table view data source
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return tableData.count
	}
	
	 func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"addCategoryCell")
		cell.textLabel?.textAlignment = NSTextAlignment.Left
		cell.textLabel?.textColor = UIColor.blackColor()
		cell.textLabel?.font = UIFont(name: "Open Sans", size: 16.0)!
		cell.detailTextLabel?.font = UIFont(name: "OpenSans-Semibold", size: 10.0)!
		let location = tableData[indexPath.row]
		
		var locality = location.locality
		if (locality.isEmpty) {
			locality = location.adminArea
		}
		cell.textLabel?.text = "\(locality)"
	
		if (locality.isEmpty){
			cell.textLabel?.text = "\(location.county)"
		}else {
			cell.detailTextLabel?.text = "\(location.county)"
		}
		return cell
	}
	
	func searchBarCancelButtonClicked(searchBar: UISearchBar) {
		tableData = []
		searchResultsTable.reloadData()
	
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		searchController.active = false
		let selectedLocation = tableData[indexPath.row]
		delegate?.didSelectLocation(selectedLocation)
	}
    
	//MARK: - UISearchControllerDelegate
	
	func didPresentSearchController(searchController: UISearchController) {
		searchController.searchBar.becomeFirstResponder()
	}
    
	//MARK: UISearchResultsUpdater delegate
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		
		UIView.animateWithDuration(0.3, animations: { () -> Void in
			if self.tableData.isEmpty {
				self.badgeView.alpha = 1.0
				self.searchResultsTable.alpha = 0.0
			}else {
				self.badgeView.alpha = 0.0
				self.searchResultsTable.alpha = 1.0
			}
		})
		
		let locationManager = LocationManager.init()
		
		let searchTerms = searchController.searchBar.text
		if ( searchTerms?.characters.count > 1) {
			
			locationManager.searchForLocationWithName(searchTerms!, completionHandler: { (searchResults, error) -> () in
				
				self.tableData.removeAll(keepCapacity: false)
				self.tableData = searchResults as [Location]
				self.searchResultsTable.reloadData()
			})
		}
	}
	
}


