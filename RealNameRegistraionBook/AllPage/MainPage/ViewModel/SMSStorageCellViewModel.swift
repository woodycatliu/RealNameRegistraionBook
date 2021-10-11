//
//  SMSStorageCellViewModel.swift
//  RealNameRegistraionBook
//
//  Created by Woody Liu on 2021/9/29.
//

import Foundation

class SMSStorageCellViewModel {
    
    enum Pattern {
        case selection
        case normal
        
        func next()-> Pattern {
            if self == .normal {
                return .selection
            }
            return .normal
        }
    }
    
    @Published
    var pettern: Pattern = .normal
    
    @Published
    var selectionCache: Set<IndexPath> = []
    
    @Published
    private(set) var selectedAllCache: Set<Int> = []
    
    private let service: CoreDataService = .shared
    
    func isSelected(indexPath: IndexPath?)-> Bool {
        guard let indexPath = indexPath else {
              return false
        }
        return selectionCache.contains(where: { $0 == indexPath })
    }
    
    
    func isSelectedAll(section: Int)-> Bool {
        return selectedAllCache.contains(section)
    }
    
    func selectedAll(section: Int) {
        guard let group = service.getGroup(section),
              !group.placeList.isEmpty else { return }
        let places = group.placeList
        var cache = Set<IndexPath>()
        for i in places.indices {
            cache.insert(IndexPath(item: i, section: section))
        }
        selectedAllCache.insert(section)
        selectionCache = selectionCache.union(cache)
    }
    
    func removedSelectedAll(section: Int) {
        guard let group = service.getGroup(section) else { return }
        let places = group.placeList
        var cache = Set<IndexPath>()
        for i in places.indices {
            cache.insert(IndexPath(item: i, section: section))
        }
        selectedAllCache.remove(section)
        selectionCache.subtract(cache)
    }
    
}


extension SMSStorageCellViewModel {
    
    func toggleSelection() {
        selectionCache.removeAll()
        selectedAllCache.removeAll()
        let pettern = pettern
        self.pettern = pettern.next()
    }
    
    func deleteSelected() {
        guard !selectionCache.isEmpty else { return }
        service.deletePlaces(indexPaths: Array(selectionCache))
    }
    
    func removeToGroup(section: Int) {
        guard !selectionCache.isEmpty else { return }
        print(selectionCache)
        print(Array(selectionCache))
        service.removeToGroup(indexPaths: Array(selectionCache), groupSection: section)
    }
    
}
