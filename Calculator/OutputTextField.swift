//
//  OutputTextField.swift
//  Calculator
//
//  Created by Peter Vorwieger on 03.12.16.
//  Copyright © 2016 Peter Vorwieger. All rights reserved.
//

import Cocoa

class OutputTextField: NSTextField {

    func defaultFont(_ fontSize:CGFloat) -> NSFont {
        return NSFont.systemFont(ofSize: fontSize)
    }

    override func draw(_ dirtyRect: NSRect) {
        let size = calculateFontSize(self.bounds.size)
        self.font = defaultFont(size)
        
        let bSize = boudingSize(bounds.size, fontSize:size)
        let offset = frame.size.height - bSize.height
        self.frame = NSRect(x: frame.origin.x, y: 20.0 - offset/2, width: frame.size.width, height: frame.size.height)
        super.draw(dirtyRect)
    }
    
    func attributes(_ fontSize:CGFloat) -> [NSAttributedStringKey : Any] {
        let font = defaultFont(fontSize)
        let color = NSColor.white
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = NSParagraphStyle.LineBreakMode.byCharWrapping
        return [
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.foregroundColor: color,
            NSAttributedStringKey.paragraphStyle: style
        ]
    }
    
    func boudingSize(_ size: NSSize, fontSize _fontSize:CGFloat) -> NSSize {
        let attr = attributes(_fontSize)
        let options = NSString.DrawingOptions.usesLineFragmentOrigin
        let rect = (stringValue as NSString).boundingRect(with: size, options: options, attributes: attr)
        return rect.size
    }
    
    func calculateFontSize(_ size: NSSize) -> CGFloat {
        let _fontSize:CGFloat = 36
        let bounds = boudingSize(size, fontSize: _fontSize)
        let scale = min(size.width / bounds.width, size.height / bounds.height)
        return floor(max(scale * _fontSize, _fontSize)) - 5.0
    }
    
}
