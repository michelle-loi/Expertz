import SwiftUI

struct Theme {
    // A deep teal for primary UI elements
    static let primaryColor = Color(red: 0/255, green: 120/255, blue: 130/255)
    
    // Often used for backgrounds or secondary text
    static let secondaryColor = Color.white
    
    // A brighter aqua accent for highlights or buttons
    static let accentColor = Color(red: 0/255, green: 180/255, blue: 170/255)
    
    // Spacing and corner styles
    static let buttonPadding: CGFloat = 40.0
    static let cornerRadius: CGFloat = 100.0
    
    // Font styles
    static let titleFont = Font.largeTitle
    // A slightly darker teal for prominent text, or you can match primaryColor
    static let titleFontColour = Color(red: 0/255, green: 63/255, blue: 67/255)
    static let inputFont: Font = .system(size: 16)
}
