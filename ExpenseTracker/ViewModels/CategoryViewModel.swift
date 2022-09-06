//
//  CategoryViewModel.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/5/22.
//

import SwiftUI

class CategoryViewModel: ObservableObject {
  
  @Published var storedCategory: CategoryModel?
  
  @Published var name = ""
  @Published var symbol = "photo"
  @Published var symbolColor = Color.brandPrimary
  @Published var red = 0.0
  @Published var green = 0.0
  @Published var blue = 0.0
  @Published var alpha = 0.0
  
  func makeCategoryModel() {
    getColor()
    let newCategory = CategoryModel(name: name, symbol: symbol, colorR: red, colorG: green, colorB: blue, colorA: alpha)
    storedCategory = newCategory
  }
  
  func getColor() {
    red = symbolColor.components.r
    green = symbolColor.components.g
    blue = symbolColor.components.b
    alpha = symbolColor.components.a
  }
  
  @Published var symbolsArray: [String] = [
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
}
