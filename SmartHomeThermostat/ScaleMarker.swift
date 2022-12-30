//
//  ScaleMarker.swift
//  SmartHomeThermostat
//
//  Created by Sean Howard on 30/12/2022.
//

import SwiftUI

struct ScaleMarker: View {
    
    @Binding var fillColor: Color
    
    var body: some View {
        Trapezoid(percent: 10)
            .fill(fillColor)
            .frame(width: 6, height: 22)
            .rotationEffect(.degrees(180))
            .cornerRadius(20)
            .animation(.linear(duration: 1), value: fillColor)
    }
}

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
