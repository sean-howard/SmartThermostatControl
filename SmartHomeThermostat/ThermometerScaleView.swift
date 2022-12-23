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
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = 25

    private var degreeRange: CGFloat { config.maximumAngle - config.minimumAngle }
    private var degreesOfSeparation: CGFloat { degreeRange / CGFloat(config.numberOfMarkers) }
    
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
        .rotationEffect(.degrees(config.minimumAngle - (degreesOfSeparation * 0.5)))
        .rotationEffect(.degrees(Double(line) * degreesOfSeparation - 180.0))
    }
    
    private var thermostatMeasurements: some View {
        ZStack {
            HStack {
                Text("10°")
                Spacer()
                Text("30°")
            }
            
            VStack {
                Text("20°")
                Spacer()
            }
        }
        .frame(width: 390 - 2 * horizontalPadding, height: 390 - 2 * verticalPadding)
        .font(.subheadline)
        .foregroundColor(.white.opacity(0.3))
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
