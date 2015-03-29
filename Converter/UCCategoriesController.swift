 //
//  UCUnitsTableViewController.swift
//  Convert
//
//  Created by Mikhail Burshteyn on 12/2/14.
//  Copyright (c) 2014 Southern Company. All rights reserved.
//

import UIKit

class UCCategoriesController : UITableViewController, UISplitViewControllerDelegate {
    
    let data = UCBL.getCategories();
    var delegate : UCResultsController!;
    private var collapse = true;
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitViewController!.delegate = self;
        splitViewController!.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible;
        var resultsController = (splitViewController!.viewControllers[1] as UINavigationController).topViewController as UCResultsController;
        self.delegate = resultsController;
        
        UCBL.category = UCBL.getCategories()[0];
        UCBL.unit = UCBL.getCategories()[0].Units[0];
        UCBL.value = "";
        
        self.clearsSelectionOnViewWillAppear = true;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChange:", name: UIKeyboardWillShowNotification, object: nil);
        
    }

    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if (toInterfaceOrientation == UIInterfaceOrientation.Portrait)
        {
            collapse = false;
        }
        else
        {
            //For iPhone 6+ restore state after rotation
            if (scale == 3)
            {
                let category = UCBL.category;
                let index = find(data, category)
                tableView.selectRowAtIndexPath(NSIndexPath(forRow: index!, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None);
                delegate.keyboardView?.changeUnit(false);
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if (!splitViewController!.collapsed)
        {
            let category = UCBL.category;
            let index = find(data, category)
            tableView.selectRowAtIndexPath(NSIndexPath(forRow: index!, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None);
            delegate.keyboardView?.changeUnit(false);
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow()
        {
            tableView.deselectRowAtIndexPath(indexPath, animated: true);
        }
    }
    
    //MARK: - Keyboard
    func keyboardChange(notification: NSNotification)
    {
        //Change inset for tableview
        if (!splitViewController!.collapsed)
        {
            let userInfo = notification.userInfo!
            let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
            let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
            
            var inset = tableView.contentInset;
            if (keyboardViewEndFrame.height > 100)
            {
                inset.bottom = keyboardViewEndFrame.height;
            }
            tableView.contentInset = inset;
            tableView.scrollToNearestSelectedRowAtScrollPosition(UITableViewScrollPosition.None, animated: true);
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = data[indexPath.row].description.uppercaseString;
        cell.imageView?.image = UIImage(named: data[indexPath.row].description.lowercaseString);
        return cell
    }
    
    //MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = (segue.destinationViewController as UINavigationController).topViewController as UCResultsController;
        UCBL.category = data[tableView.indexPathForSelectedRow()!.row];
        UCBL.unit = UCBL.category.Units[0];
        UCBL.value = "";
        self.delegate = controller;
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        //Do not perform segue if parent and child are visible
        if (!splitViewController!.collapsed)
        {
            UCBL.category = data[tableView.indexPathForSelectedRow()!.row];
            UCBL.unit = UCBL.category.Units[0];
            delegate.changeCategory();
            return false;
        }
        return true;
    }
    
    //MARK: - Split View
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool
    {
        if (collapse)
        {
            collapse = false;
            return true;
        }
        return false;
    }
}
