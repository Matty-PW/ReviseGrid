//
//  Colour+Hex.swift
//  RevisionWidgetExtension
//
//  Created by Matty on 15/09/2026.
//

import SwiftUI

extension Color {
    init(hex: String) {
        var hexValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&hexValue)
        
        let red = Double((hexValue & 0xFF0000) >> 16) / 255
        let green = Double((hexValue & 0x00FF00) >> 8) / 255
        let blue = Double(hexValue & 0x0000FF) / 255

        self.init(red: red, green: green, blue: blue)
    }
    
    init(light: String, dark: String) {
        self = Color(uiColor: UIColor { traits in
            UIColor(Color(hex: traits.userInterfaceStyle == .dark ? dark : light))
        })
    }
}
