//
//  CustomModofiers.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/24/22.
//

import SwiftUI

//MARK: Buttons
struct ScanButtonStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .foregroundColor(.white)
      .frame(height: 55)
      .frame(maxWidth: .infinity)
      .background(Color("ScanButtonColor"))
      .cornerRadius(10)
      .padding(.horizontal)
  }
}

struct AddButtonStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .foregroundColor(.white)
      .frame(height: 55)
      .frame(maxWidth: .infinity)
      .background(Color.brandPrimary)
      .cornerRadius(10)
      .padding(.horizontal)
  }
}

struct DeleteButtonStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .foregroundColor(.white)
      .frame(height: 55)
      .frame(maxWidth: .infinity)
      .background(Color.red)
      .cornerRadius(10)
      .padding(.horizontal)
  }
}

struct ToolBarButtonStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.footnote)
      .padding(.horizontal)
      .padding(.vertical, 4)
      .foregroundColor(.white)
      .background(Color.brandPrimary)
      .clipShape(Capsule())
  }
}

struct TextfieldStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .frame(height: 55)
      .padding(.horizontal)
      .background(.white)
      .cornerRadius(10)
      .padding(.horizontal)
  }
}
