//
//  ProspectsView.swift
//  HotProspects
//
//  Created by saj panchal on 2021-08-25.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    @State var isShowingScanner = false
    @State var sortResult = false
    enum FilterType {
        case none, contacted, uncontacted
    }
    let filter: FilterType
    var title: String {
        switch filter {
            case .none:
                return "Everyone"
            case .contacted:
                return "Contacted People"
            case .uncontacted:
                return "Uncontacted people"
        }
    }
    var filteredProspects: [Prospect] {
        switch filter {
            case .none:
                return prospects.people
            case .contacted:
                return prospects.people.filter {
                    $0.isContacted
                }
            case .uncontacted:
                return prospects.people.filter {
                    !$0.isContacted
                }
            }
        }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        if prospect.isContacted {
                            Image(systemName: "checkmark.circle")
                        }
                        else {
                            Image(systemName: "questionmark.diamond")
                        }
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                    }
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" :
                                "Mark Contacted") {
                            self.prospects.toggle(prospect)
                        }
                        if !prospect.isContacted {
                            Button("Remind Me") {
                                self.addNotification(for: prospect)
                            }
                        }
                    }
                }
            }
                .navigationBarTitle(title)
            .actionSheet(isPresented: $sortResult, content: {
                ActionSheet(title: Text("Sort Contact List"), message: Text("Choose Options..."), buttons: [
                    .default(Text("By Name")) {
                         prospects.people.sort {
                            $0.name < $1.name
                        }
                    },
                                .default(Text("By Most Recent")) {
                                    prospects.people.sort {
                                        $0.id > $1.id
                                    }
                                },
                    .cancel()
                ])
            })
            .navigationBarItems(leading: Button(action: {
                self.sortResult = true
            }, label: {
                Text("Filter")
            }) ,trailing: Button(action: {
                    self.isShowingScanner = true
                }, label: {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                }))
            
            .sheet(isPresented: $isShowingScanner, content: {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Saj Panchal\nsajpanchal@gmail.com", completion: self.handleScan)
            })
            /**/
            
          
             
        
        }
    }
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
            case .success(let code):
                let details = code.components(separatedBy: "\n")
                guard details.count == 2 else {
                    return
                }
                let person = Prospect()
                person.name = details[0]
                person.emailAddress = details[1]
                self.prospects.add(person)
            case .failure(_):
                print("Scanning failed")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        //create notificationcenter object
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            // create a content to show in notification
            let content = UNMutableNotificationContent()
            content.title = "Content \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            // date component
            var dateComponents = DateComponents()
            dateComponents.hour = 9 //set hour
            //create a trigger object with calendar notification.
           // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            // now create a request
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            //add request to the notificationcenter object.
            center.add(request)
        }
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            }
            else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    }
                    else {
                        print("D'oh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
