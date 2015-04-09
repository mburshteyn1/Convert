//
//  UCUnitPickerDelegate.swift
//  Convert
//
//  Created by Mikhail Burshteyn on 12/3/14.
//  Copyright (c) 2014 Southern Company. All rights reserved.
//

import UIKit

class UCUnitDelegate : NSObject, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var data : Array<Unit>
    var delegate : UCInputView!;

    init(category : BaseCategory) {
        self.data = category.Units;
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count;
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        calculate(data[pickerView.selectedRowInComponent(0)]);
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView
    {
        var label = view as? UILabel;
        if (label == nil)
        {
            label = UILabel(frame: CGRectMake(0, 0, pickerView.frame.width, 50));
        }
        label!.text = data[row].Name.uppercaseString;
        label!.textAlignment = NSTextAlignment.Center;
        label!.font = UIFont.systemFontOfSize(idiom == .Pad ? 20 : 16, weight: UIFontWeightLight);
        label!.textColor = UIColor(red: 8/255, green: 69/255, blue: 126/255, alpha: 1);
        return label!;
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count + 2;
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell;
        var label = cell.subviews[0].subviews[0] as! UILabel;
        label.text = "";
        if (indexPath.row > 0 && indexPath.row <= data.count)
        {
            label.text = data[indexPath.row - 1].Name.uppercaseString;
        }
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width / 3, 40);
    }
   
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset;
        calculate(snapToCellWithOffset(offset.x, scrollView: scrollView, animated: true));
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var offset = targetContentOffset.memory;
        calculate(snapToCellWithOffset(offset.x, scrollView: scrollView, animated: true));
    }
    
    func snapToCellWithOffset(offset: CGFloat, scrollView: UIScrollView, animated: Bool) -> Unit
    {
        var center = offset + screenWidth / 2;
        var num = Int(center / cellWidth) - 1;
        var left = num * Int(cellWidth);
        scrollView.setContentOffset(CGPointMake(CGFloat(left), 0), animated: animated);
        if (animated)
        {
            UIDevice.currentDevice().playInputClick();
        }
        return data[num];
    }
    
    func calculate(unit: Unit)
    {
        UCBL.unit = unit;
        delegate.calculate();
    }
}
