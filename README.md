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

# Architecure

The app is structured in MVVM. The files are structured by **Scenes**, and within each contains a **Views** and a **ViewModels** folder.

CoreData is handled in its own CoreDataManager class, and is passed to views that need it through the **environmentObject**.

 
