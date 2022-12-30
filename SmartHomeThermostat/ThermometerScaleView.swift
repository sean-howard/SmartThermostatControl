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

    var currentDegrees: CGFloat = 0
    private var degreesOfSeparation: CGFloat { config.angleRange / CGFloat(config.numberOfMarkers) }
    
    var body: some View {
        ZStack {
            ForEach(0..<config.numberOfMarkers, id: \.self) { line in
                scaleLine(at: line)
            }
            .frame(width: scaleSize, height: scaleSize)
                
            targetMarker
                .frame(width: scaleSize * 1.05, height: scaleSize * 1.05)
        }
    }
    
    private func scaleLine(at line: Int) -> some View {
        VStack {
            ScaleMarker(fillColor: .constant(scaleLineFillColor(at: line)))
            Spacer()
        }
        .rotationEffect(.degrees(config.minimumAngle))
        .rotationEffect(.degrees(Double(line) * degreesOfSeparation - 180.0))
    }
    
    private var targetMarker: some View {
        VStack {
            Trapezoid(percent: 10)
                .fill(.white)
                .frame(width: 8, height: 36)
                .rotationEffect(.degrees(180))
                .cornerRadius(20)
            Spacer()
        }
        .rotationEffect(.degrees(currentDegrees - 180.0))
        .animation(.easeInOut(duration: 1), value: currentDegrees)
    }
    
    private func scaleLineFillColor(at line: Int) -> Color {
        let lowerThreshold = currentDegrees - 120
        let linePositionDegrees = (Double(line) * degreesOfSeparation) + config.minimumAngle
        
        if linePositionDegrees > currentDegrees {
            return .blue.opacity(0.03)
        }
        
        if linePositionDegrees < lowerThreshold {
            return .blue
        }

        let range = currentDegrees - lowerThreshold
        let correctedStartValue = linePositionDegrees - lowerThreshold
        let percentage = correctedStartValue / range
        
        var opacity = abs(1-percentage)
        if opacity < 0.04 { opacity = 0.04 }
        
        return .blue.opacity(opacity)
    }
}

struct ThemometerScaleView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerScaleView(currentDegrees: 0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
    }
}
