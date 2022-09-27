//
//  GlobalTools.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 9/6/22.
//

import SwiftUI
import Combine

class GlobalTools: ObservableObject {

  @Published var myFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()
  
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
