//
//  CategoryPickerView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 8/31/22.
//

import SwiftUI

struct NewCategorySheet: View {
  @EnvironmentObject var data: CoreDataManager
  
  @StateObject var viewModel = CategoryViewModel()
  
  @State var symbolColor = Color.brandPrimary
  @Binding var isPresented: Bool
  
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
        TextField("Category name", text: $viewModel.name)
          .textfieldStyle()
        Image(systemName: viewModel.symbol)
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
              viewModel.symbol = symbolsArray[symbol]
              viewModel.red = Double(symbolColor.components.r)
              viewModel.green = Double(symbolColor.components.g)
              viewModel.blue = Double(symbolColor.components.b)
              viewModel.alpha = Double(symbolColor.components.a)
              
              viewModel.makeCategoryModel()
              
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
        if let category = viewModel.storedCategory {
          data.addCategory(category)
        }
        viewModel.storedCategory = nil
        data.fetchCategories()
        isPresented = false
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
    NewCategorySheet(isPresented: .constant(true))
      .environmentObject(CoreDataManager())
  }
  
}
