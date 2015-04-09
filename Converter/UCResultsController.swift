//
//  UCResultsController.swift
//  Converter
//
//  Created by Mikhail Burshteyn on 3/22/15.
//  Copyright (c) 2015 Mikhail Burshteyn. All rights reserved.
//

import UIKit

class UCResultsController: UITableViewController {
    
    var data : [Unit]?;
    var keyboardView : UCInputView!;
    var accessoryView : UITextField!;
    private var txtHidden : UITextField!;
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let category = UCBL.category;
        data = category.convert(0.0, from: category.Units[0]);
        self.navigationItem.title = "";
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChange:", name: UIKeyboardDidChangeFrameNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil);
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let category = UCBL.category;
        self.navigationItem.title = category.description.uppercaseString;
        
        //Load Keyboard
        var array = NSBundle.mainBundle().loadNibNamed("InputView", owner: self, options: nil);
        //Load landscape or portrain keyboard view
        keyboardView = array[!splitViewController!.collapsed || orientation == UIDeviceOrientation.LandscapeLeft || orientation == UIDeviceOrientation.LandscapeRight ? 0 : 1] as! UCInputView;
        keyboardView.delegate = self;
        keyboardView.changeCategory();
        
        accessoryView = array[2] as! UITextField;
        accessoryView.frame = CGRectMake(0, 0, 0, idiom == .Pad ? 60 : 44);
        accessoryView.font = UIFont.systemFontOfSize(idiom == .Pad ? 32 : 26, weight: UIFontWeightThin);
        accessoryView.addTarget(self, action: "calculate", forControlEvents: UIControlEvents.EditingChanged);
        accessoryView.layer.borderColor = UIColor(white: 230.0/255.0, alpha: 1).CGColor;
        accessoryView.layer.borderWidth = 1/scale;
        accessoryView.tintColor = UIColor(red: 8/255, green: 69/255, blue: 126/255, alpha: 1);
        accessoryView.text = UCBL.value;

        //Create a hidden textfield to show keyboard initialy.
        txtHidden = UITextField(frame: CGRectMake(0, 0, 0, 0));
        txtHidden.hidden = true;
        txtHidden.inputView = keyboardView;
        txtHidden.inputAccessoryView = accessoryView;
        self.view.addSubview(txtHidden);
        txtHidden.becomeFirstResponder();
        
        accessoryView.inputView = keyboardView;
        accessoryView.becomeFirstResponder();
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        //Change Keyboard view on rotation for iPhone
        if (idiom == .Phone)
        {
            var array = NSBundle.mainBundle().loadNibNamed("InputView", owner: self, options: nil);
            keyboardView = array[toInterfaceOrientation == UIInterfaceOrientation.LandscapeLeft || toInterfaceOrientation == UIInterfaceOrientation.LandscapeRight ? 0 : 1] as! UCInputView;
            keyboardView.delegate = self;
            keyboardView.changeCategory();
            accessoryView.inputView = keyboardView;
            accessoryView.reloadInputViews();
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Keyboard
    func keyboardDidShow(notification: NSNotification)
    {
        if (idiom == .Phone && keyboardView != nil)
        {
            if (scale == 3)
            {
                accessoryView.reloadInputViews();
                accessoryView.becomeFirstResponder();
            }
            keyboardView.changeUnit(false);
        }
    }
    func keyboardChange(notification: NSNotification)
    {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        
        var inset = tableView.contentInset;
        if (keyboardViewEndFrame.height > 100)
        {
            inset.bottom = keyboardViewEndFrame.height;
        }
        tableView.contentInset = inset;
    }
    
    func btnKeyboardTap(sender: UIButton) {
        if (sender.titleLabel!.text == nil)
        {
            accessoryView.deleteBackward();
        }
        //Limit legth to 19
        else if (accessoryView.text.length < 19)
        {
            var formatter = NSNumberFormatter();
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle;
            formatter.usesGroupingSeparator = true;
            formatter.maximumFractionDigits = 20;
            
            if (sender.titleLabel!.text == "." && accessoryView.text.rangeOfString(".") != nil)
            { /*Do not add more than one period */ }
            else if (sender.titleLabel!.text == ".")
            {
                accessoryView.insertText(sender.titleLabel!.text!);
            }
            else if (sender.titleLabel!.text == "0" && accessoryView.text.rangeOfString(".") != nil)
            {
                accessoryView.insertText(sender.titleLabel!.text!);
            }
            else
            {
                accessoryView.insertText(sender.titleLabel!.text!);
                var number = formatter.numberFromString(accessoryView.text.stringByReplacingOccurrencesOfString(",", withString: "", options: nil, range: nil))!;
                accessoryView.text = formatter.stringFromNumber(number);
            }
        }
        UCBL.value = accessoryView.text;
    }

    //MARK: - Misc
    func calculate()
    {
        let value = accessoryView.text.stringByReplacingOccurrencesOfString(",", withString: "", options: nil, range: nil).doubleValue;
        let unit = UCBL.unit;
        let category = UCBL.category;
        data = category.convert(value ?? 0, from: unit);
        
        tableView.reloadData();
    }
    func changeCategory()
    {
        let category = UCBL.category;
        self.navigationItem.title = category.description.uppercaseString;
        keyboardView?.changeCategory();
        calculate();
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        if let unit = data?[indexPath.row]
        {
            cell.textLabel?.text = unit.Name.uppercaseString;
            
            var formatter = NSNumberFormatter();
            formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle;
            formatter.maximumFractionDigits = 7;// - Int((unit.Value < Double(Int.max) ? unit.Value : 0) / 100);
            formatter.minimumFractionDigits = 0;
            formatter.usesGroupingSeparator = true;
            
            var number = formatter.stringFromNumber(NSNumber(double: unit.Value));
            if (number?.length > 15 || (unit.Value > 0 && unit.Value < 0.000001))
            {
                formatter.numberStyle = NSNumberFormatterStyle.ScientificStyle;
                number = formatter.stringFromNumber(NSNumber(double: unit.Value));
                
                //Highlight E if exponent
                var atts = [NSFontAttributeName: cell.detailTextLabel!.font];
                var base = NSMutableAttributedString(string: number!.componentsSeparatedByString("E")[0], attributes: atts);
                var temp = number!.componentsSeparatedByString("E")[1];
                if temp.length == 1
                {
                    temp = "0" + temp;
                }
                var exponent = NSMutableAttributedString(string: temp, attributes: atts);
                atts = [NSFontAttributeName: UIFont.systemFontOfSize(cell.detailTextLabel!.font.pointSize)];
                var e = NSMutableAttributedString(string: "e", attributes: atts);
                base.appendAttributedString(e);
                base.appendAttributedString(exponent);
                cell.detailTextLabel?.attributedText = base;
            }
            else
            {
                cell.detailTextLabel?.text = formatter.stringFromNumber(NSNumber(double: unit.Value));
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    override func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject) -> Bool {
        return action == "copy:";
    }
    override func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) {
        UIPasteboard.generalPasteboard().string = tableView.cellForRowAtIndexPath(indexPath)?.detailTextLabel?.text;
    }
}
