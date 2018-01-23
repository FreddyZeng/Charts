//
//  SleepMarkerView.swift
//  Meum
//
//  Created by fanrong on 2017/11/29.
//  Copyright © 2017年 huangwei. All rights reserved.
//

//
//  XYMarkerView.swift
//  ChartsDemo
//  Copyright © 2016 dcg. All rights reserved.
//

import Foundation


@objc open protocol TYMarkerViewDelegate {
    @objc open func tyMarkerViewRefreshContentAttString(mark:TYMarkerView, entry: ChartDataEntry, highlight: Highlight) -> NSAttributedString
}

open class TYMarkerView: BalloonMarker
{
    @objc open weak var delegate: TYMarkerViewDelegate?
    
    fileprivate var yFormatter = NumberFormatter()
    
    @objc public override init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        yFormatter.minimumFractionDigits = 0
        yFormatter.maximumFractionDigits = 0
        
        minimumSize = CGSize(width:32.0, height: 19.0);
        offset = CGPoint(x: 0, y: -3)
        arrowSize = CGSize(width:10, height:6);
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        if let delegate = delegate {
            let attString = delegate.tyMarkerViewRefreshContentAttString(mark: self, entry: entry, highlight: highlight)
            setAttLabel(attString);
        }
    }
}

