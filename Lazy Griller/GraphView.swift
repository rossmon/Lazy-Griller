//
//  GraphView.swift
//  Wifi Grill
//
//  Created by Ross Montague on 7/6/15.
//  Copyright (c) 2015 MontagueTech. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable class GraphView: UIView {
    
    
    //Weekly sample data
    var probeTempPoints:[Int] = [Int]()
    var probeTimeVals:[NSDate] = [NSDate]()
    
    var maxTime = 0;
    var minTime = 0;
    
    var width:CGFloat = CGFloat()
    var height:CGFloat = CGFloat()
    var dataPointSpacer:CGFloat = CGFloat()
    
    let margin:CGFloat = 15.0
    let topBorder:CGFloat = 60
    let bottomBorder:CGFloat = 50
    
    var probeReadings:[TempReading] = [TempReading]()
    
    //1 - the properties for the gradient
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()
    
    func setPoints(preadings: [TempReading]) {
        probeReadings = preadings
        
        for index in stride(from: 0, to: preadings.count, by: 1) {
            probeTempPoints.append(Int(preadings[index].temp!))
            probeTimeVals.append(preadings[index].datetime!)
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        width = rect.width
        height = rect.height
        
        
        //set up background clipping area
        var path = UIBezierPath(roundedRect: rect,
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSize(width: 8.0, height: 8.0))
        path.addClip()
        
        //2 - get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        
        //6 - draw the gradient
        var startPoint = CGPoint.zeroPoint
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context,
            gradient,
            startPoint,
            endPoint,
            0)
        
        
        
        let graphHeight = height - topBorder - bottomBorder
        
        if probeTempPoints.count > 1 {
            //calculate the x point
            let maxXValue = probeTimeVals[(probeTimeVals.count-1)]
            let minXValue = probeTimeVals[0]
            let minuteDiff = maxXValue.timeIntervalSinceDate(minXValue)/60
            
            dataPointSpacer = CGFloat(self.probeTempPoints.count - 1)
            
            var columnXPoint = { (column:Int) -> CGFloat in
                //Calculate gap between points
                let spacer = (((self.width - (20 * self.dataPointSpacer)) - self.margin*2 - 4) / self.dataPointSpacer)
                var x:CGFloat = CGFloat(column) * spacer
                x += self.margin + 2 + 20
                return x
            }
            
            // calculate the y point
            let minValue: CGFloat = CGFloat(minElement(probeTempPoints)) - 10
            let maxValue = maxElement(probeTempPoints) + 10
            
            var columnYPoint = { (graphPoint:Int) -> CGFloat in
                var y:CGFloat = (CGFloat(graphPoint)-minValue) /
                    (CGFloat(maxValue)-minValue) * graphHeight
                y = graphHeight + self.topBorder - y // Flip the graph
                return y
            }
            
            // draw the line graph
            UIColor.whiteColor().setFill()
            UIColor.whiteColor().setStroke()
            
            //set up the points line
            var graphPath = UIBezierPath()
            //go to start of line
            graphPath.moveToPoint(CGPoint(x:columnXPoint(0),
                y:columnYPoint(probeTempPoints[0])))
            
            //add points for each item in the graphPoints array
            //at the correct (x, y) for the point
            for i in 1..<probeTempPoints.count {
                let nextPoint = CGPoint(x:columnXPoint(i),
                    y:columnYPoint(probeTempPoints[i]))
                graphPath.addLineToPoint(nextPoint)
            }
            
            //graphPath.stroke()
            /*
            //START TEMP TEST
            
            //Create the clipping path for the graph gradient
            
            //1 - save the state of the context (commented out for now)
            //CGContextSaveGState(context)
            
            //2 - make a copy of the path
            var clippingPath = graphPath.copy() as! UIBezierPath
            
            //3 - add lines to the copied path to complete the clip area
            clippingPath.addLineToPoint(CGPoint(
                x: columnXPoint(probeTempPoints.count - 1),
                y:height))
            clippingPath.addLineToPoint(CGPoint(
                x:columnXPoint(0),
                y:height))
            clippingPath.closePath()
            
            //4 - add the clipping path to the context
            clippingPath.addClip()
            //END TEMP TEST
            */
            
            
            let highestYPoint = columnYPoint(maxValue)
            startPoint = CGPoint(x:margin, y: highestYPoint)
            endPoint = CGPoint(x:margin, y:self.bounds.height)
            
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
            //CGContextRestoreGState(context)
            
            //draw the line on top of the clipped gradient
            graphPath.lineWidth = 2.0
            graphPath.stroke()
            
            //Draw the circles on top of graph stroke
            for i in 0..<probeTempPoints.count {
                var point = CGPoint(x:columnXPoint(i), y:columnYPoint(probeTempPoints[i]))
                point.x -= 5.0/2
                point.y -= 5.0/2
                
                let circle = UIBezierPath(ovalInRect:
                    CGRect(origin: point,
                        size: CGSize(width: 5.0, height: 5.0)))
                circle.fill()
                if i == 0 || i == (probeTempPoints.count-1) {
                    createLabel(columnXPoint(i), y: CGFloat(height - 12), textDate: probeTimeVals[i])
                }
                
            }

        }
        
        
        //Draw horizontal graph lines on the top of everything
        var linePath = UIBezierPath()
        
        //top line
        linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin,
            y:topBorder))
        
        //center line
        linePath.moveToPoint(CGPoint(x:margin,
            y: 2*graphHeight/3 + topBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y: 2*graphHeight/3 + topBorder))
        
        //center line
        linePath.moveToPoint(CGPoint(x:margin,
            y: graphHeight/3 + topBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:graphHeight/3 + topBorder))
        
        //bottom line
        linePath.moveToPoint(CGPoint(x:margin,
            y:height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
    
    func getXPoint(int: Int, dataPointSpacer: CGFloat) -> CGFloat {
        //Calculate gap between points
        let spacer = (((self.width - (20 * dataPointSpacer)) - self.margin*2 - 4) / dataPointSpacer)
        var x:CGFloat = CGFloat(int) * spacer
        x += self.margin + 2 + 20
        return x
    }
    
    func createLabel(x: CGFloat, y: CGFloat, textDate: NSDate){
        var label = UILabel(frame: CGRectMake(0, 0, 50, 20))
        label.center = CGPointMake(x, y)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "Avenir Next Condensed", size:16)
        label.textColor = UIColor.whiteColor()
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: textDate)
        var hour = components.hour
        if hour > 12 {
            hour = hour - 12
        }
        let minutes = components.minute
        
        
        var dateString = "\(hour):\(minutes)"
        label.text = dateString
        self.insertSubview(label, aboveSubview: self)
    }
}
