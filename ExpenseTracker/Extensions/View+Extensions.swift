//
//  View+Extensions.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/28/22.
//

import Foundation
import SwiftUI

extension Image {
  public init(data: Data?, placeholder: String) {
    guard let data = data,
          let uiImage = UIImage(data: data) else {
      self = Image(systemName: "photo")
      return
    }
    self = Image(uiImage: uiImage)
  }
}

struct StrokeStyle: ViewModifier {
  var cornerRadius: CGFloat
  @Environment(\.colorScheme) var colorScheme
  
  func body(content: Content) -> some View {
    content.overlay(
      RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .stroke(
          .linearGradient(
            colors: [
              .white.opacity(colorScheme == .dark ? 0.6 : 0.3),
              .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
            ], startPoint: .top, endPoint: .bottom
          )
        )
        .blendMode(.overlay)
    )
  }
}

struct CardBackground: ViewModifier {
  func body(content: Content) -> some View {
    content
      .background(.ultraThickMaterial, in: RoundedRectangle(
        cornerRadius: 16,
        style: .continuous))
      .background(Color.white.cornerRadius(16).shadow(color: Color.secondary.opacity(0.2), radius: 50, x: 0, y: 0))
      .strokeStyle(cornerRadius: 16)
  }
}

struct CenterInView: ViewModifier {
  func body(content: Content) -> some View {
    HStack {
      Spacer()
      content
      Spacer()
    }
  }
}

extension View {
  func textfieldStyle() -> some View {
    modifier(TextfieldStyle())
  }
  func scanButtonStyle() -> some View {
    modifier(ScanButtonStyle())
  }
  
  func addButtonStyle() -> some View {
    modifier(AddButtonStyle())
  }
  
  func deleteButtonStyle() -> some View {
    modifier(DeleteButtonStyle())
  }
  func strokeStyle(cornerRadius: CGFloat = 30) -> some View {
    modifier(StrokeStyle(cornerRadius: cornerRadius))
  }
  
  func centerInView() -> some View {
    modifier(CenterInView())
  }
  
  func toolBarButtonStyle() -> some View {
    modifier(ToolBarButtonStyle())
  }
  
  func cardBackground() -> some View {
    modifier(CardBackground())
  }
}


