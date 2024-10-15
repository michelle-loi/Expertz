//
//  ViewModifier.swift
//  Expertz
//
//  Created by Alan Huynh on 2024-10-14.
//

import SwiftUI
// ViewModifier is used to apply multiple modifications on a single object.
// Create a struct similar to the ones below and add them to the extension view

// Template:
// struct [modifier name]: ViewModifier {
//      func body(content: Content) -> some View {
//          content
//              [modifications]
//      }
//  }


// Modifier for Green Button, White Text
struct CTADesignButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Theme.accentColor)
            .foregroundColor(Theme.secondaryColor)
            .cornerRadius(Theme.cornerRadius)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Theme.primaryColor, lineWidth: 2)
            )
            .padding(Theme.buttonPadding)

    }
}

// Modifier for White Button, Green Text
struct AlternativeDesignButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Theme.secondaryColor)
            .foregroundColor(Theme.primaryColor)
            .cornerRadius(Theme.cornerRadius)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Theme.accentColor, lineWidth: 2)
            )
            .padding(Theme.buttonPadding)

    }
}


// Extending View to make it easier to apply these modifiers
extension View {
    //  Template:
    //  func [method name] -> some View {
    //      self.modifier([modifer name])
    //  }
    
    func customCTADesignButton() -> some View {
        self.modifier(CTADesignButton())
    }
    func customAlternativeDesignButton() -> some View {
        self.modifier(AlternativeDesignButton())
    }
}
