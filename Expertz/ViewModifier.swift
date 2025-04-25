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
            .font(Theme.inputFont.bold())
            .frame(maxWidth: .infinity)
            .background(Theme.primaryColor)
            .foregroundColor(Theme.secondaryColor)
            .cornerRadius(Theme.cornerRadius)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Theme.primaryColor, lineWidth: 2)
            )
            .padding(.horizontal, Theme.buttonPadding)

    }
}

// Modifier for White Button, Green Text
struct AlternativeDesignButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(Theme.inputFont.bold())
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .foregroundColor(Theme.primaryColor)
            .cornerRadius(Theme.cornerRadius)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Theme.primaryColor, lineWidth: 2)
            )
            .padding(.horizontal, Theme.buttonPadding)

    }
}

// Modifier for Text Input Field:
struct FormInputField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(Theme.cornerRadius)
            .font(Theme.inputFont)
            .foregroundColor(Theme.primaryColor)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Theme.primaryColor, lineWidth: 2)
            )
            .padding(.horizontal, Theme.buttonPadding)

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
    func customFormInputField() -> some View {
        self.modifier(FormInputField())
    }
}
