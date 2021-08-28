//
//  Prospect.swift
//  HotProspects
//
//  Created by saj panchal on 2021-08-25.
//

import Foundation

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var isContacted = false
}

class Prospects: ObservableObject {
    @Published var people: [Prospect]
    static let saveKey = "SavedData"
    
    init() {
        let url = Self.getDocumentsDirectory().appendingPathComponent("contacts.txt")
        if  let data = try? Data(contentsOf: url) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
        }
        self.people = []
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
     func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            let url = Self.getDocumentsDirectory().appendingPathComponent("contacts.txt")
            do {
                try encoded.write(to: url)
            }
            catch {
                
            }
           // UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
}
