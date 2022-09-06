//
//  CategoryPickerView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/31/22.
//

import SwiftUI

struct NewCategorySheet: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var data: CoreDataManager
  
  @StateObject var vm = CategoryViewModel()
  
  @State var symbolColor = Color.brandPrimary
  @State private var nameText: String = ""
  @State private var currentSymbol: String = "photo"
  
  let symbolsArray: [String] = [
    "car.fill",
    "fuelpump.fill",
    "trash.fill",
    "doc.text.fill",
    "book.fill",
    "books.vertical.fill",
    "graduationcap.fill",
    "magazine.fill",
    "paperclip",
    "flag.fill",
    "bell.fill",
    "camera.fill",
    "gear",
    "scissors",
    "wallet.pass.fill",
    "amplifier",
    "dice.fill",
    "paintbrush.fill",
    "bandage.fill",
    "wrench.fill",
    "hammer.fill",
    "screwdriver.fill",
    "wrench.and.screwdriver.fill",
    "stethoscope",
    "printer.fill",
    "briefcase.fill",
    "suitcase.fill",
    "puzzlepiece.fill",
    "lock.fill",
    "key.fill",
    "pin.fill",
    "mappin.circle.fill",
    "map.fill",
    "powerplug.fill",
    "radio.fill",
    "guitars.fill",
    "bed.double.fill",
    "cube.fill",
    "clock.fill",
    "gamecontroller.fill",
    "stopwatch.fill",
    "fork.knife",
    "takeoutbag.and.cup.and.straw.fill",
    "hourglass",
    "battery.100",
    "lightbulb.fill",
    "airplane",
    "bus.fill",
    "person.fill",
    "person.crop.rectangle.fill",
    "tshirt.fill",
    "hand.thumbsup.fill",
    "hands.sparkles.fill",
    "globe.americas.fill",
    "flame.fill",
    "drop.fill",
    "bolt.fill",
  ]
  
  let columns = [
    GridItem(.adaptive(minimum: 40))
  ]
  
  var body: some View {
    VStack {
      HStack {
        TextField("Category name", text: $nameText)
          .textfieldStyle()
        Image(systemName: currentSymbol)
          .resizable()
          .scaledToFit()
          .frame(width: 30, height: 30)
          .foregroundColor(symbolColor)
          .padding(.trailing)
      }
      .cardBackground()
      .padding()
      ColorPicker("Set the symbol color", selection: $symbolColor)
        .padding()
      ScrollView {
        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(0..<symbolsArray.count) { symbol in
            Button {
              currentSymbol = symbolsArray[symbol]
              let red = Double(symbolColor.components.r)
              let green = Double(symbolColor.components.g)
              let blue = Double(symbolColor.components.b)
              let alpha = Double(symbolColor.components.a)
              
              vm.makeCategoryModel(name: nameText, symbol: currentSymbol, colorR: red, colorG: green, colorB: blue, colorA: alpha)
              
              if let category = vm.storedCategory {
                data.addCategory(category)
              }
              
              vm.storedCategory = nil
              
              data.fetchCategories()
              
              presentationMode.wrappedValue.dismiss()
            } label: {
              Image(systemName: symbolsArray[symbol])
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(symbolColor)
            }
          }
        }
      }
      .padding()
      Button {
        
      } label: {
        Text("Add Category")
          .addButtonStyle()
      }
    }
    .background(Color(.secondarySystemBackground))
  }
}

struct NewCategorySheet_Previews: PreviewProvider {
  static var previews: some View {
    NewCategorySheet()
      .environmentObject(CoreDataManager())
  }
  
}
