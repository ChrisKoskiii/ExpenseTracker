# ExpenseTracker

ExpenseTracker is a fully featured Expense Tracking application built in SwiftUI

Technologies used: 

* **Swift**
* **SwiftUI**
* **CoreData** for data persistence
* **CloudKit** to allow multi device syncing
* **PDFKit** for generating and exporting PDF reports
* **VisionKit** for document scanning

<img src="https://i.imgur.com/c94Kqla.png" width="200" height="425" />

## Architecure

The app is structured in MVVM. The files are structured by **Scenes**, and within each contains a **Views** and a **ViewModels** folder.

CoreData is handled in its own CoreDataManager class, and is passed to views that need it through the **environmentObject**.

## Features

* **Document scanning**; Users can scan and save receipts for each expense entered. That image is converted to raw data to allow saving to Core Data.
* **Generate PDF Reports**; Users can generete expense reports for a chosen time frame. This was done with **PDFKit**. To implement, I had to use a UIViewControllerRepresentable to make it work with SwiftUI.
* **Category symbol customization**; Users can create custom vendors and categories that create reltionships in Core Data to the expense entity. Symbols can be created using SF Symbols and SwiftUI's ColorPicker.
* **CloudKit intergration**; CoreData uses a **NSPersistentCloudKitContainer** to save data to iCloud. This lets users have their expenses on all of the their devices without worrying about a username or password.


 
