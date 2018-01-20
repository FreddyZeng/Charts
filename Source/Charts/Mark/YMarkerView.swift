//
//  YMarkerView.swift
//  Meum
//
//  Created by fanrong on 2017/11/28.
//  Copyright © 2017年 huangwei. All rights reserved.
//

import Foundation

open class YMarkerView: BalloonMarker
{
    fileprivate var yFormatter = NumberFormatter()
    
    @objc public var digits:Int {
        set{
            yFormatter.minimumFractionDigits = newValue
            yFormatter.maximumFractionDigits = newValue
        }
        get {
           return yFormatter.minimumFractionDigits
        }
    }
    
    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                      xAxisValueFormatter: IAxisValueFormatter)
    {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        yFormatter.minimumFractionDigits = 0
        yFormatter.maximumFractionDigits = 0
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        if entry.y == 0.0 {
             setLabel("")
        }else {
            let string = yFormatter.string(from: NSNumber(value: entry.y))
            if let string = string,string.count > 0 {
                setLabel(string)
            }else {
                setLabel("")
            }
        }
    }
}
