//
//  ThermostatConfiguration.swift
//  SmartHomeThermostat
//
//  Created by Sean Howard on 23/12/2022.
//

import SwiftUI

struct ThermostatConfiguration {
    
    static let standard = ThermostatConfiguration(
        temperature: .init(
            minimum: 6,
            maximum: 35
        ),
        viewConfig: .init(
            startAngle: 20, // Not implemented yet
            endAndle: 340, // Not implemented yet
            numberOfMarkers: 50,
            scaleFillColor: .blue,
            targetTemperatureIndicatorColor: .white
        )
    )
    
    let temperature: Temperature
    let viewConfig: ViewConfig

    struct Temperature {
        let minimum: CGFloat
        let maximum: CGFloat
    }
    
    struct ViewConfig {
        /// Denotes the starting point for scale markers, where 0 degrees is at the bottom, 6 o'clock
        /// Not implemented yet
        let startAngle: CGFloat
        
        /// Denotes the ending point for scale markers, where 0 degrees is at the bottom, 6 o'clock
        /// Not implemented yet
        let endAndle: CGFloat

        /// Number of temperature scale markers drawn around the circumference of the visible scale.
        let numberOfMarkers: Int

        /// The base colour for the control, opacity will be calculated from this for fades
        let scaleFillColor: Color
        
        /// The colour for the target temperature indicator
        let targetTemperatureIndicatorColor: Color
    }

    /// Degrees of rotation per unit of temperature
    var degreesPerTemperatureUnit: CGFloat { 9 }
    
    /// Total number of markers on 360 circumference
    var markersOnCircumference: CGFloat {
        360 / degreesPerTemperatureUnit
    }
    
    // TODO: - Refactor
    /// To be replaced by `ViewConfig.startAngle` and `ViewConfig.endAngle` which are declared in order to reverse these calculations
    /// so `degreesPerTemperatureUnit` can be calculated dynamically rather than being hardcoded.
    var minimumAngle: CGFloat { temperature.minimum * degreesPerTemperatureUnit }
    var maximumAngle: CGFloat { temperature.maximum * degreesPerTemperatureUnit }
    var angleRange: CGFloat { maximumAngle - minimumAngle }
}
