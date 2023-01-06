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
    
    /// Draws a new scale marker with a rectangular frame and rotates it by `markerSpacingDegrees` each time around a centre point
    /// - Parameter line: Index of scale marker
    /// - Returns: View
    private func scaleMarker(at line: Int) -> some View {
        VStack {
            ScaleMarker(fillColor: .constant(scaleLineFillColor(at: line)))
            Spacer()
        }
        .rotationEffect(.degrees(config.minimumAngle))
        .rotationEffect(.degrees(Double(line) * markerSpacingDegrees - 180.0))
    }
    
    /// Draws the white marker line indicating the target temperature
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
    
    /// Returns a fill colour for the scale marker based on it's position, and it's proximity either side of the target temperature depending on its proximity to make a fade effect.
    /// - Parameter line: Index of scale marker
    /// - Returns: Fill color
    private func scaleLineFillColor(at line: Int) -> Color {
        let linePositionDegrees = (Double(line) * markerSpacingDegrees) + config.minimumAngle
        
        if linePositionDegrees > currentDegrees {
            return colourAfterTarget(linePositionDegrees: linePositionDegrees)
        } else {
            return colourBeforeTarget(linePositionDegrees: linePositionDegrees)
        }
    }
    
    /// Calculates the fill colour for scale markers positioned AFTER the target temperature marker
    /// - Parameter linePositionDegrees: Angular position of the scale marker
    /// - Returns: Fill colour
    private func colourAfterTarget(linePositionDegrees: CGFloat) -> Color {
        
        if linePositionDegrees < targetDegrees {
            let upperThreshold = currentDegrees + 30
            let range = upperThreshold - currentDegrees
            
            /// The the scale marker position falls between the `currentDegree + 30º` then calculate it's relative position as a percentage
            /// Map the percentage to an opacity to apply to the colour so it fades from a solid colour to "off"
            if linePositionDegrees > currentDegrees && linePositionDegrees < upperThreshold {
                
                let scaledStartValue = linePositionDegrees - upperThreshold
                var opacity = abs(scaledStartValue / range)
                
                if opacity < 0.04 { opacity = 0.04 }
                return .blue.opacity(opacity)
            }
        }
        return .blue.opacity(0.03) // Default OFF colour
    }
    
    /// Calculates the fill colour for scale markers positioned BEFORE the target temperature marker
    /// - Parameter linePositionDegrees: Angular position of the scale marker
    /// - Returns: Fill colour
    private func colourBeforeTarget(linePositionDegrees: CGFloat) -> Color {
                
        if linePositionDegrees > targetDegrees {
            let lowerThreshold = currentDegrees - 120
            let range = currentDegrees - lowerThreshold
            let scaledStartValue = linePositionDegrees - lowerThreshold
            let percentage = scaledStartValue / range
            
            var opacity = abs(1-percentage)
            if opacity < 0.04 { opacity = 0.04 }

            return .blue.opacity(opacity)
        }
        
        // If the scaler marker falls outside of the threshold for a fade then return the default ON colour
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
