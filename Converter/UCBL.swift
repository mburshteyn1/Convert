//
//  UCBL.swift
//  Convert
//
//  Created by Mikhail Burshteyn on 12/2/14.
//  Copyright (c) 2014 Southern Company. All rights reserved.
//

import Foundation
import UIKit

//Global variables
var scale : CGFloat
{
    return UIScreen.mainScreen().scale;
}
var idiom : UIUserInterfaceIdiom
{
    return UIDevice.currentDevice().userInterfaceIdiom;
}
var cellWidth : CGFloat
{
    return UIScreen.mainScreen().bounds.width / 3;
}
var screenWidth : CGFloat
{
    return UIScreen.mainScreen().bounds.width;
}
var orientation : UIDeviceOrientation
{
    return UIDevice.currentDevice().orientation;
}
public class UCBL {
    
    public class func getCategories() -> Array<BaseCategory>
    {
        var result = [
            BaseCategory(name: "Angle", data: [
                Unit(name: "Degree", value: 360),
                Unit(name: "Grad", value: 400),
                Unit(name: "Radian", value: 6.28318531),
                Unit(name: "Revolutions", value: 1),
                Unit(name: "Right Angles", value: 4),
                Unit(name: "Seconds", value: 1296000),
                Unit(name: "Minute", value: 21600)
                ]),
            BaseCategory(name: "Area", data: [
                Unit(name: "Acre", value: 640),
                Unit(name: "Hectare", value: 258.999),
                Unit(name: "Square cm", value: 25899900000),
                Unit(name: "Square meters", value: 2589990),
                Unit(name: "Square Kilometers", value: 2.58999),
                Unit(name: "Square inches", value: 4014489600),
                Unit(name: "Square feet", value: 27878400),
                Unit(name: "Square miles", value: 1),
                Unit(name: "Square yards", value: 3097600)
                ]),
            BaseCategory(name: "Distance", data: [
                Unit(name: "millimeters", value: 1609340),
                Unit(name: "centimeters", value: 160934),
                Unit(name: "meters", value: 1609.34),
                Unit(name: "Kilometers", value: 1.60934),
                Unit(name: "inches", value: 63360),
                Unit(name: "feet", value: 5280),
                Unit(name: "yards", value: 1760),
                Unit(name: "miles", value: 1),
                Unit(name: "mils", value: 63360000)]),
            BaseCategory(name: "Energy", data: [
                Unit(name: "BTU", value: (3.41214163*pow(10, 9))),
                Unit(name: "Electron Volts", value: (2.24694336*pow(10, 31))),
                Unit(name: "Watt Hours", value: 1000000000),
                Unit(name: "Kilowatt Hours", value: 1000000),
                Unit(name: "Gigawatt Hours", value: 1),
                Unit(name: "Horsepower Hours", value: 1341022.09)
                ]),
            BaseCategory(name: "Mass", data:[
                Unit(name: "grams", value: 1016046.91),
                Unit(name: "Kilograms", value: 1016.04691),
                Unit(name: "ounces", value: 35840),
                Unit(name: "pounds", value: 2240),
                Unit(name: "stones", value: 160),
                Unit(name: "Tons (long)", value: 1),
                Unit(name: "Tons (short)", value: 1.12)]),
            BaseCategory(name: "Power", data:[
                Unit(name: "BTU/h", value: 3412141.63),
                Unit(name: "Horsepower", value: 1341.02209),
                Unit(name: "watts", value: 1000000),
                Unit(name: "Kilowatts", value: 1000),
                Unit(name: "Megawatts", value: 1)]),
            BaseCategory(name: "Pressure", data:[
                Unit(name: "Atmosphere", value: 9.869233),
                Unit(name: "MicroBar", value: 10000000),
                Unit(name: "Millibar", value: 10000),
                Unit(name: "Bar", value: 1341.02209),
                Unit(name: "MM of Mercury", value: 7500.617),
                Unit(name: "CM of Mercury", value: 750.0617),
                Unit(name: "IN of Mercury", value: 295.2999),
                Unit(name: "Pascal", value: 1000000),
                Unit(name: "KiloPascal", value: 1000),
                Unit(name: "MegaPascal", value: 1),
                Unit(name: "KG/CM²", value: 10.19716),
                Unit(name: "KG/M²", value: 101971.6),
                Unit(name: "LB/IN² (PSI)", value: 145.0377),
                Unit(name: "LB/FT²", value: 20885.43)]),
            BaseCategory(name: "Speed", data: [
                Unit(name: "feet/second", value: 1.466667),
                Unit(name: "miles/second", value: 0.0002777778),
                Unit(name: "miles/hour", value: 1),
                Unit(name: "meters/second", value: 0.44704),
                Unit(name: "kilometers/second", value: 0.00044704),
                Unit(name: "kilometers/hour", value: 1.609344),
                Unit(name: "knot", value: 0.8689762),
                Unit(name: "mach", value: 0.0013487),
                Unit(name: "light (C)", value: 1.491165*pow(10, -9))]),
            TemperatureCategory(name: "Temperature", data:[
                Unit(name: "Celsius", value: 1),
                Unit(name: "Fahrenheit", value: 1),
                Unit(name: "Kelvin", value: 1),
                Unit(name: "Rankine", value: 1)]),
            BaseCategory(name: "Volume", data:[
                Unit(name: "cubic centimeter", value: 764554.858),
                Unit(name: "cubic meter", value: 0.764554858),
                Unit(name: "cubic inch", value: 46656),
                Unit(name: "cubic feet", value: 27),
                Unit(name: "cubic yards", value: 1),
                Unit(name: "milliliters", value: 764554.858),
                Unit(name: "liters", value: 764.554858),
                Unit(name: "teaspoons", value: 155116.052),
                Unit(name: "tablespoons", value: 51705.3506),
                Unit(name: "ounces", value: 25852.6753),
                Unit(name: "cups", value: 3231.58442),
                Unit(name: "pints", value: 1615.79221),
                Unit(name: "quarts", value: 807.896104),
                Unit(name: "gallons", value: 201.974026)]),
        ];
        return result;
    }
    
    class func backgroundImage(color: UIColor) -> UIImage
    {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    class var category : BaseCategory
    {
        get
        {
            var index = NSUserDefaults.standardUserDefaults().valueForKey("category") as Int
            return UCBL.getCategories()[index];
        }
        set
        {
            var index = find(UCBL.getCategories(), newValue);
            NSUserDefaults.standardUserDefaults().setInteger(index!, forKey: "category");
            NSUserDefaults.standardUserDefaults().synchronize();
        }
    }
    class var unit : Unit
    {
        get
        {
            var index = NSUserDefaults.standardUserDefaults().valueForKey("unit") as Int
            return UCBL.category.Units[index];
        }
        set
        {
            var index = find(UCBL.category.Units, newValue);
            NSUserDefaults.standardUserDefaults().setInteger(index!, forKey: "unit");
            NSUserDefaults.standardUserDefaults().synchronize();
        }
    }
    class var value : String
    {
        get
    {
        return NSUserDefaults.standardUserDefaults().valueForKey("value") as String
        }
        set
    {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "value");
            NSUserDefaults.standardUserDefaults().synchronize();
        }
    }
}

extension String
{
    var isNumeric : Bool
        {
        get
        {
            var count = 0;
            for char in self
            {
                if (char == ".")
                {
                    count++;
                }
                if (count > 1)
                {
                    return false;
                }
            }
            return self.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "0123456789.").invertedSet) == nil;
        }
    }
    
    var doubleValue : Double?
        {
            return self.length > 0 ? (self as NSString).doubleValue : nil;
    }
    var integerValue : Int?
        {
            return self.length > 0 ? (self as NSString).integerValue : nil;
    }
    var length : Int
        {
            return (self as NSString).length;
    }
}
