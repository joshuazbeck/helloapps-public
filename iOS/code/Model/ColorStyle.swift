//
//  ColorStyle.swift
//  Hello Color
//
//  Created by Josh Beck on 3/28/24.
//

import Foundation
import SwiftUI

/// Holds a reference to the model used to represent a color style element
class ColorStyle: Identifiable, Hashable /** for ForEach conformity */ {
    var id: String {
        return UUID().uuidString // Generates a unique ID which is used by state to determine when to re-render the view
    }
    
    // Provides conformity to the Hashable protocol
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    // Provides conformity to the Hashable protocol
    static func == (lhs: ColorStyle, rhs: ColorStyle) -> Bool {
        return lhs.id == rhs.id
    }
    
    var hex: String
    var name: String
    var style: StyleType
    
    // Safely unwrapped Color
    public var color: Color {
        get {
            return Color(hex: hex) ?? .black
        }
    }
    
    // Dynamic initializer
    init(hex: String, name: String, style: StyleType) {
        self.hex = hex
        self.name = name
        self.style = style
    }
}

// An enum is a predefined class defining options
enum StyleType: String {
    case primary = "Primary"
    case secondary = "Secondary"
    case tertiary = "Tertiary"
    case background = "Background"
    case accent = "Accent"
}
