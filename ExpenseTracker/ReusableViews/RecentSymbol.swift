//
//  RecentSymbol.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/1/22.
//

import SwiftUI

struct RecentSymbol: View {
  var symbol: String
  var color: Color
    var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .foregroundColor(Color(uiColor: .systemGray6))
          .frame(width: 45, height: 45)
        Image(systemName: symbol)
          .resizable()
          .scaledToFit()
          .frame(width: 30, height: 30)
          .foregroundColor(color)
      }
    }
}

struct RecentSymbol_Previews: PreviewProvider {
    static var previews: some View {
      RecentSymbol(symbol: "fuelpump.fill", color: Color.black)
    }
}
