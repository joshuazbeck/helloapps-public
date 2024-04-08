//
//  Text.swift
//  Color Clocks
//
//  Created by Josh Beck on 3/28/24.
//

import Foundation
import SwiftUI

// @credit - Dallin Jared
extension View {
    func setContrast(backgroundColor: Color) -> some View {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        UIColor(backgroundColor).getRed(&r, green: &g, blue: &b, alpha: &a)
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  luminance < 0.6 ? self.foregroundColor(.white) : self.foregroundColor(.black)
    }
}
