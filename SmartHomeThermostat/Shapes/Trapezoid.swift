//
//  Trapezoid.swift
//  SmartHomeThermostat
//
//  Created by Sean Howard on 06/01/2023.
//

import SwiftUI

struct Trapezoid: Shape {
    @State var percent: Double
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let edge = rect.width * CGFloat(percent/100)
        path.move(to: CGPoint(x: rect.minX + edge, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - edge, y: rect.minY ))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY ))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
