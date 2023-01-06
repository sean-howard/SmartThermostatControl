//
//  TemperatureFormatter.swift
//  SmartHomeThermostat
//
//  Created by Sean Howard on 30/12/2022.
//

import Foundation

struct TemperatureFormatter {
    static func formatted(celcius: CGFloat) -> String {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.minimumFractionDigits = 1
        formatter.numberFormatter.maximumFractionDigits = 1
                
        let temperature = Measurement(value: celcius, unit: UnitTemperature.celsius)
        // Hard coded to always show celcius. "en_US" will do an automatic conversion from celcious to farenheit
        formatter.locale = Locale(identifier: "en_GB")
        return formatter.string(from: temperature)
    }
}
