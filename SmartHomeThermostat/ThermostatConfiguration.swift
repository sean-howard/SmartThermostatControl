//
//  ThermostatConfiguration.swift
//  SmartHomeThermostat
//
//  Created by Sean Howard on 23/12/2022.
//

import Foundation

struct ThermostatConfiguration {
    
    static let standard = ThermostatConfiguration(
        temperature: .init(
            minimum: 6,
            maximum: 35
        ),
        numberOfMarkers: 50
    )
    
    let temperature: Temperature

    struct Temperature {
        let minimum: CGFloat
        let maximum: CGFloat
    }

    /// Number of temperature scale markers drawn around the circumference of the visible scale.
    let numberOfMarkers: Int
    
    /// Degrees of rotation per unit of temperature
    var degreesPerTemperatureUnit: CGFloat { 9 }
    
    /// Total number of markers on 360 circumference
    var markersOnCircumference: CGFloat {
        360 / degreesPerTemperatureUnit
    }
    
    var minimumAngle: CGFloat { temperature.minimum * degreesPerTemperatureUnit }
    var maximumAngle: CGFloat { temperature.maximum * degreesPerTemperatureUnit }
    var angleRange: CGFloat { maximumAngle - minimumAngle }
}
