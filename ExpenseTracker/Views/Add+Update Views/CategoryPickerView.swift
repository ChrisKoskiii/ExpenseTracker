//
//  CategoryPickerView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/31/22.
//

import SwiftUI

struct CategoryPickerView: View {
  @Environment(\.presentationMode) var presentationMode
  
  @State var symbolColor = Color.brandPrimary
  
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
  
  @State var category: CategoryEntity?
  
  var body: some View {
    VStack {
      ColorPicker("Set the symbol color", selection: $symbolColor)
      ScrollView {
        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(0..<symbolsArray.count) { symbol in
            Button {
              let red = Double(symbolColor.components.r)
              let green = Double(symbolColor.components.g)
              let blue = Double(symbolColor.components.b)
              let alpha = Double(symbolColor.components.a)
              category?.colorA = alpha
              category?.colorB = blue
              category?.colorG = green
              category?.colorR = red 
              category!.symbol = symbolsArray[symbol]
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
    }
  }
}

struct CategoryPickerView_Previews: PreviewProvider {
  static var previews: some View {
    CategoryPickerView()
  }
}
