//
//  InputView.swift
//  Converter
//
//  Created by Mikhail Burshteyn on 3/22/15.
//  Copyright (c) 2015 Mikhail Burshteyn. All rights reserved.
//

import UIKit

class UCInputView: UIView, UIInputViewAudioFeedback{
    
    @IBOutlet weak var pickerView: UIPickerView?
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var viewInput: UIView!
    @IBOutlet weak var viewMask: UIView!
    
    var unitDelegate : UCUnitDelegate!
    var delegate : UCResultsController!
    var nib : UINib!;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        unitDelegate = UCUnitDelegate(category: UCBL.getCategories()[0]);
        unitDelegate.delegate = self;
        pickerView?.delegate = unitDelegate;
        pickerView?.dataSource = unitDelegate;
        
        collectionView?.delegate = unitDelegate;
        collectionView?.dataSource = unitDelegate;
        
        for view in viewInput.subviews as! [UIButton]
        {
            view.layer.borderColor = UIColor(white: 230.0/255.0, alpha: 1).CGColor;
            view.layer.borderWidth = 1/scale;
            view.setBackgroundImage(UCBL.backgroundImage(UIColor(red: 218/255, green: 97/266, blue: 78/255, alpha: 1)), forState: UIControlState.Highlighted);
        }
        
        nib = UINib(nibName: "UnitCell", bundle: nil);
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: "Cell");
        
        if (collectionView != nil)
        {
            var gradient = CAGradientLayer();
            gradient.colors = [UIColor(white: 0.0, alpha: 0.0).CGColor, UIColor(white: 1.0, alpha: 1.0).CGColor, UIColor(white: 0.0, alpha: 0.0).CGColor]
            gradient.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 40);
            gradient.startPoint = CGPointMake(0.0, 0.5);
            gradient.endPoint = CGPointMake(1.0, 0.5);
            viewMask.layer.mask = gradient;
        }
    }
    
    @IBAction func btnKeyboardTap(sender: UIButton) {
        UIDevice.currentDevice().playInputClick();
        delegate.btnKeyboardTap(sender);
    }
    
    func changeCategory()
    {
        let category = UCBL.category;
        unitDelegate.data = category.Units;
        pickerView?.reloadAllComponents();
        collectionView?.reloadData();
        changeUnit(idiom == .Pad);
    }
    func changeUnit(animated: Bool)
    {
        let unit = UCBL.unit;
        var index = find(UCBL.category.Units, unit)!;
        pickerView?.selectRow(index, inComponent: 0, animated: animated);
        if (collectionView != nil)
        {
            unitDelegate.snapToCellWithOffset(cellWidth * CGFloat(index), scrollView: collectionView!, animated: animated);
        }
    }
    func calculate()
    {
        delegate.calculate();
    }
    var enableInputClicksWhenVisible: Bool
    {
        return true;
    }
}
