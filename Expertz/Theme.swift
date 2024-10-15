//
//  Theme.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-14.
//

import SwiftUI

// Similar to CSS, Theme View is Global Styling for the whole app.
// Format template: static let [variable name] = [content]
// To use styling in other files: Theme.[variable]

struct Theme {
    static let primaryColor = Color(red: 0/255, green: 91/255, blue: 30/255)
    static let secondaryColor = Color.white
    static let accentColor = Color(red: 5/255, green: 198/255, blue: 154/255)
    static let buttonPadding: CGFloat = 10.0
    static let cornerRadius: CGFloat = 100.0
    static let titleFont = Font.largeTitle
    static let titleFontColour = Color(red: 0/255, green: 91/255, blue: 30/255)
}
