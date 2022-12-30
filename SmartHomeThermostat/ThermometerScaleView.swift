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
    var targetDegrees: CGFloat = 0
    
    private var markerSpacingDegrees: CGFloat { config.angleRange / CGFloat(config.numberOfMarkers) }
    
    var body: some View {
        ZStack {
            ForEach(0..<config.numberOfMarkers, id: \.self) { line in
                scaleMarker(at: line)
            }
            .frame(width: scaleSize, height: scaleSize)
                
            targetMarker
                .frame(width: scaleSize * 1.05, height: scaleSize * 1.05)
        }
    }
    
    private func scaleMarker(at line: Int) -> some View {
        VStack {
            ScaleMarker(fillColor: .constant(scaleLineFillColor(at: line)))
            Spacer()
        }
        .rotationEffect(.degrees(config.minimumAngle))
        .rotationEffect(.degrees(Double(line) * markerSpacingDegrees - 180.0))
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
        .rotationEffect(.degrees(targetDegrees - 180.0))
        .animation(.easeInOut(duration: 1), value: targetDegrees)
    }
    
    private func scaleLineFillColor(at line: Int) -> Color {
        let linePositionDegrees = (Double(line) * markerSpacingDegrees) + config.minimumAngle
        
        if linePositionDegrees > currentDegrees {
            return .blue.opacity(0.03)
        }

        return .blue
    }
}

struct ThemometerScaleView_Previews: PreviewProvider {
    static var previews: some View {
        ThermometerScaleView(currentDegrees: 0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
    }
}
