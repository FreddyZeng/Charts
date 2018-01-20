//
//  XYMarkerView.swift
//  ChartsDemo
//  Copyright © 2016 dcg. All rights reserved.
//

import Foundation

open class XYMarkerView: BalloonMarker
{
    @objc open var xAxisValueFormatter: IAxisValueFormatter?
    fileprivate var yFormatter = NumberFormatter()
    
    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: IAxisValueFormatter)
    {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 0
        yFormatter.maximumFractionDigits = 0
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        if let xAxisValueFormatter = xAxisValueFormatter {
            let string = xAxisValueFormatter.stringForValue(entry.x, axis: XAxis()) + xAxisValueFormatter.stringForValue(entry.y, axis: YAxis())
            if string.count > 0 {
                setLabel(string)
            }else {
                setLabel("")
            }
        }else {
            let string = xAxisValueFormatter?.stringForValue(entry.y, axis: YAxis())
            
            if let string = string {
                setLabel(string)
            }else {
                setLabel("")
            }
        }
    }
}
