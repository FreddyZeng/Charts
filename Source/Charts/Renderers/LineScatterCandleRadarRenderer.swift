//
//  LineScatterCandleRadarRenderer.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

@objc(LineScatterCandleRadarChartRenderer)
open class LineScatterCandleRadarRenderer: BarLineScatterCandleBubbleRenderer
{
    public override init(animator: Animator?, viewPortHandler: ViewPortHandler?)
    {
        super.init(animator: animator, viewPortHandler: viewPortHandler)
    }
    
    /// Draws vertical & horizontal highlight-lines if enabled.
    /// :param: context
    /// :param: points
    /// :param: horizontal
    /// :param: vertical
    @objc open func drawHighlightLines(context: CGContext, point: CGPoint, set: ILineScatterCandleRadarChartDataSet)
    {
        guard let
            viewPortHandler = self.viewPortHandler
            else { return }
        
        // draw vertical highlight lines
        
        if let set = set as? LineChartDataSet, set.isVerticalHighlightIndicatorEnabled {
            let cornerRadius:CGFloat = 3
            
            let pointRect = CGRect(x: point.x - cornerRadius , y: point.y - cornerRadius, width: cornerRadius * 2, height: cornerRadius * 2)
            let path = UIBezierPath.init(roundedRect: pointRect, cornerRadius:cornerRadius)
            
            path.lineWidth = 2
            context.setFillColor(set.highlightHollowFillColor.cgColor)
            path.fill()
            path.stroke()
            
            
            let bottomLineHeight = viewPortHandler.contentBottom - 10;
            
            if point.y <= bottomLineHeight {
                context.beginPath()
                context.setLineWidth(1)
                context.setLineDash(phase: 1, lengths: [2,0,2])
                context.move(to: CGPoint(x: point.x, y: point.y - cornerRadius))
                context.addLine(to: CGPoint(x: point.x, y: bottomLineHeight))
                context.strokePath()
            }
            
            if point.y <= bottomLineHeight {
                context.beginPath()
                context.setLineWidth(2)
                context.setLineDash(phase: 0, lengths: [])
                context.move(to: CGPoint(x: point.x, y: bottomLineHeight))
                context.addLine(to: CGPoint(x: point.x, y: viewPortHandler.contentBottom))
                context.strokePath()
            }
            
        }else if set.isVerticalHighlightIndicatorEnabled
        {
            context.beginPath()
            context.move(to: CGPoint(x: point.x, y: viewPortHandler.contentTop))
            context.addLine(to: CGPoint(x: point.x, y: viewPortHandler.contentBottom))
            context.strokePath()
        }
        
        // draw horizontal highlight lines
        if set.isHorizontalHighlightIndicatorEnabled
        {
            context.beginPath()
            context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: point.y))
            context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: point.y))
            context.strokePath()
        }
    }
}
