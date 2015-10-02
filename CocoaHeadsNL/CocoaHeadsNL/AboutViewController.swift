//
//  AboutViewController.swift
//  CocoaHeadsNL
//
//  Created by Berend Schotanus on 02-10-15.
//  Copyright © 2015 Stichting CocoaheadsNL. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 140.0;
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
}
