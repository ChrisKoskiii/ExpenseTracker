//
//  NavBar.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/29/22.
//

import SwiftUI

struct NavigationBar: View {
  @ObservedObject var coreVM: CoreDataViewModel
  @ObservedObject var expensesVM: ExpensesViewModel
  var title = ""
  @Binding var hasScrolled: Bool
  
  var body: some View {
    ZStack {
      Color.clear
        .background(.ultraThinMaterial)
        .blur(radius: 10)
        .opacity(hasScrolled ? 1 : 0)
      Text(title)
        .font(.largeTitle.weight(.bold))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 20)
        .padding(.top, 20)
        .offset(y: hasScrolled ?  -4 : 0)
      
      HStack(spacing: 16) {
        NavigationLink(destination: AddExpenseView(expensesVM: expensesVM)) {
          Image(systemName: "plus")
            .font(.body.weight(.bold))
            .frame(width: 36, height: 36)
            .foregroundColor(.secondary)
            .background(.ultraThinMaterial, in:
                          RoundedRectangle(cornerRadius: 14, style: .continuous)
            )
            .strokeStyle(cornerRadius: 14)
        }
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.trailing, 20)
      .padding(.top, 20)
      .offset(y: hasScrolled ?  -4 : 0)
    }
    .navigationBarHidden(true)
    .frame(height: hasScrolled ? 44 : 70)        .frame(maxHeight: .infinity, alignment: .top)
  }
}

struct NavigationBar_Previews: PreviewProvider {
  static var previews: some View {
    NavigationBar(coreVM: CoreDataViewModel(), expensesVM: ExpensesViewModel(), title: "Featured", hasScrolled: .constant(false))
  }
}
