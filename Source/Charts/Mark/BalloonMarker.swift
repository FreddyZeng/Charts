//
//  BalloonMarker.swift
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation


open class BalloonMarker: MarkerImage
{
    @objc open var color: UIColor?
    @objc open var arrowSize = CGSize(width: 15, height: 11)
    @objc open var font: UIFont?
    @objc open var textColor: UIColor?
    @objc open var insets = UIEdgeInsets()
    @objc open var minimumSize = CGSize()
    
    fileprivate var attLabel: NSAttributedString?
    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedStringKey : Any]()
    
    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        super.init()
        
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        let size = self.size
        var point = point
        point.x -= size.width / 2.0
        point.y -= size.height
        return super.offsetForDrawing(atPoint: point)
    }
    
    func drawLabel(context: CGContext, point: CGPoint, label: String)  {
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()
        
        if label.count == 0 {
            context.restoreGState()
            return;
        }
        
        if let color = color
        {
            context.setFillColor(color.cgColor)
            
            let path = UIBezierPath.init(roundedRect: CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height - arrowSize.height), cornerRadius: 5);
            
            let sanJiao = UIBezierPath();
            sanJiao.move(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            sanJiao.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width / 2.0,
                y: rect.origin.y + rect.size.height))
            sanJiao.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            path.append(sanJiao)
            path.fill()
        }
        
        rect.origin.y += self.insets.top
        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        label.draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    func drawAttLabel(context: CGContext, point: CGPoint, label: NSAttributedString)  {
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()
        
        if label.string.count == 0 {
            context.restoreGState()
            return;
        }
        
        if let color = color
        {
            context.setFillColor(color.cgColor)
            
            let path = UIBezierPath.init(roundedRect: CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height - arrowSize.height), cornerRadius: 5);
            
            let sanJiao = UIBezierPath();
            sanJiao.move(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            sanJiao.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width / 2.0,
                y: rect.origin.y + rect.size.height))
            sanJiao.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            path.append(sanJiao)
            path.fill()
        }
        
        rect.origin.y += self.insets.top
        rect.origin.x += self.insets.left
        rect.size.width -= self.insets.left + self.insets.right
        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        label.draw(in: rect)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        if let attLabel = attLabel,attLabel.string.count > 0 {
            drawAttLabel(context: context, point: point, label: attLabel)
        }else if let label = label,label.count > 0 {
            drawLabel(context: context, point: point, label: label)
        }
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        setLabel(String(entry.y))
    }
    
    @objc open func setAttLabel(_ newAttLabel: NSAttributedString)
    {
        attLabel = newAttLabel
        _labelSize = newAttLabel.size()
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
    
    @objc open func setLabel(_ newLabel: String)
    {
        label = newLabel
        
        _drawAttributes.removeAll()
        _drawAttributes[NSAttributedStringKey.font] = self.font
        _drawAttributes[NSAttributedStringKey.paragraphStyle] = _paragraphStyle
        _drawAttributes[NSAttributedStringKey.foregroundColor] = self.textColor
        
        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
