//
//  ThermometerScaleView.swift
//  SmartHomeThermostat
//
//  Created by Sean Howard on 21/12/2022.
//

import SwiftUI

struct ThermometerScaleView: View {
    
    private let config = ThermostatConfiguration.standard
    private let scaleSize: CGFloat = 300

    private var degreesOfSeparation: CGFloat { config.angleRange / CGFloat(config.numberOfMarkers) }
    
    var body: some View {
        ZStack {
            ForEach(0..<config.numberOfMarkers, id: \.self) { line in
                scaleLine(at: line)
            }
            .frame(width: scaleSize, height: scaleSize)
        }
    }
    
    func scaleLine(at line: Int) -> some View {
        VStack {
            Trapezoid(percent: 10)
                .fill(Color("Scale Line"))
                .frame(width: 6, height: 22)
                .rotationEffect(.degrees(180))
                .cornerRadius(20)
            Spacer()
        }
        .rotationEffect(.degrees(config.minimumAngle))
        .rotationEffect(.degrees(Double(line) * degreesOfSeparation - 180.0))
    }
}

struct ThemometerScaleView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerScaleView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
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
