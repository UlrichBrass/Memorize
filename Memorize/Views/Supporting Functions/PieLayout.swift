//
//  PieLayout.swift
//  Memorize
//
//  Created by Ulrich Braß on 02.06.20.
//  Copyright © 2020 Ulrich Braß. All rights reserved.
//

import SwiftUI

// The Shape protocol will be used here for custom drawing of a pacman like pie shaped background, used for card animation
//
// A Shape is a view, however the Shape protocol (by extension) implements View’s body var for us.
// But it introduces its own func that we are required to implement ...
// That func will create and return a Path that draws anything we want. Path has many functions to support drawing
//

struct PieLayout : Shape {
    var startAngle : Angle
    var endAngle : Angle
    var clockwise : Bool = false
    
    // all shapes are animatable by default
    // There is a struct that implements VectorArithmetic called AnimatablePair. AnimatablePair combines two VectorArithmetics into
    // one VectorArithmetic (you can also have AnimatablePairs of AnimatablePairs, so you can animate all you want)
    var animatableData: AnimatablePair<Double, Double>{ // Type has to implement the protocol VectorArithmetic point number
        // The getting of this var is the animation system getting the start/end points of an animation.
        get{
            return AnimatablePair(startAngle.radians, endAngle.radians)
            
        }
        // The setting of this var is the animation system telling the Shape/VM which piece to draw.
        set{
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect : CGRect) -> Path { // rect is the space offered for drawing
        let center = CGPoint(x : rect.midX, y : rect.midY) // center of the rectangle rect
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x : center.x + radius * cos(CGFloat(startAngle.radians)),
            y : center.y + radius * sin(CGFloat(startAngle.radians))
        )
        var p = Path()
        
        // draw pie
            p.move(to: center)
            p.addLine(to : start)
            p.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
            p.addLine(to: center)
        //
        
        return p // return a Path
    }
}

