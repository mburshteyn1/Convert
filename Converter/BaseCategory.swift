//
//  BaseCategory.swift
//  Convert
//
//  Created by Mikhail Burshteyn on 12/3/14.
//  Copyright (c) 2014 Southern Company. All rights reserved.
//

import Foundation

public struct Unit : Equatable
{
    var Name : String;
    var Value : Double;
    
    init(name : String, value: Double)
    {
        Name = name;
        Value = value;
    }
}

public func ==(lhs: Unit, rhs: Unit) -> Bool {
    return lhs.Name == rhs.Name && lhs.Value == rhs.Value;
}

public func ==(lhs: BaseCategory, rhs: BaseCategory) -> Bool {
    return lhs.description == rhs.description;
}

public class BaseCategory : Equatable {
    
    var description : String!;
    var Units : Array<Unit>;
    
    init(name: String, data : [Unit])
    {
        Units = data;
        description = name;
    }
    
    func convert(value : Double, from : Unit) -> [Unit]
    {
        var result = [Unit]();
        for unit in Units
        {
            result.append(Unit(name: unit.Name, value: (1.0 / from.Value * unit.Value * value)));
        }
        
        return result;
    }
}

public class TemperatureCategory : BaseCategory
{
    public override func convert(value: Double, from: Unit) -> [Unit] {
        var result = [Unit]();
        if (from.Name == "Celsius")
        {
            for unit in Units
            {
                if (unit.Name == "Celsius")
                {
                    result.append(Unit(name: unit.Name, value: value));
                }
                if (unit.Name == "Fahrenheit")
                {
                    result.append(Unit(name: unit.Name, value: value * 9 / 5 + 32));
                }
                if (unit.Name == "Kelvin")
                {
                    result.append(Unit(name: unit.Name, value: value + 273.15));
                }
                if (unit.Name == "Rankine")
                {
                    result.append(Unit(name: unit.Name, value: (value + 273.15) * 9 / 5));
                }
            }
        }
        if (from.Name == "Fahrenheit")
        {
            for unit in Units
            {
                if (unit.Name == "Celsius")
                {
                    result.append(Unit(name: unit.Name, value: (value - 32) * 5 / 9));
                }
                if (unit.Name == "Fahrenheit")
                {
                    result.append(Unit(name: unit.Name, value: value));
                }
                if (unit.Name == "Kelvin")
                {
                    result.append(Unit(name: unit.Name, value: (value + 459.67) * 5 / 9));
                }
                if (unit.Name == "Rankine")
                {
                    result.append(Unit(name: unit.Name, value: value + 459.67));
                }
            }
        }
        if (from.Name == "Kelvin")
        {
            for unit in Units
            {
                if (unit.Name == "Celsius")
                {
                    result.append(Unit(name: unit.Name, value: value - 273.15));
                }
                if (unit.Name == "Fahrenheit")
                {
                    result.append(Unit(name: unit.Name, value: value * 9 / 5 - 459.67));
                }
                if (unit.Name == "Kelvin")
                {
                    result.append(Unit(name: unit.Name, value: value));
                }
                if (unit.Name == "Rankine")
                {
                    result.append(Unit(name: unit.Name, value: value * 9 / 5));
                }
            }
        }
        if (from.Name == "Rankine")
        {
            for unit in Units
            {
                if (unit.Name == "Celsius")
                {
                    result.append(Unit(name: unit.Name, value: (value - 491.67) * 5 / 9));
                }
                if (unit.Name == "Fahrenheit")
                {
                    result.append(Unit(name: unit.Name, value: value - 459.67));
                }
                if (unit.Name == "Kelvin")
                {
                    result.append(Unit(name: unit.Name, value: value * 5 / 9));
                }
                if (unit.Name == "Rankine")
                {
                    result.append(Unit(name: unit.Name, value: value));
                }
            }
        }
        return result;
    }
}