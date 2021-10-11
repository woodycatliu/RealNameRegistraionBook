//
//  NSPersistentContainer+Extension.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/25.
//

import Foundation
import CoreData

let appTransactionAuthorName = "RealNameRegistraionBook"

extension NSPersistentContainer {
    func backgroundContext() -> NSManagedObjectContext {
        let context = newBackgroundContext()
        context.transactionAuthor = appTransactionAuthorName
        return context
    }
}

enum ContextSaveContextualInfo: NotificationEventProtocol {
    case `default`
    var notificationName: Notification.Name {
        return .symbol
    }

}


extension NSManagedObjectContext {
    /**
     Handles save error by post notification
     */
    private func handleSavingError(_ error: Error, contextualInfo: ContextSaveContextualInfo) {
        Logger.log(message: "Context saving error: \(error)")
        NotificationCenter.default.post(name: contextualInfo.notificationName, object: nil, userInfo: ["error": error])
    }
    
    /**
     Save a context, or handle the save error (for example, when there data inconsistency or low memory).
     */
    func save(with contextualInfo: ContextSaveContextualInfo) {
        guard hasChanges else { return }
        do {
            try save()
        } catch {
            handleSavingError(error, contextualInfo: contextualInfo)
        }
    }
}
