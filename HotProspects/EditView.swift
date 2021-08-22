//
//  EditView.swift
//  HotProspects
//
//  Created by saj panchal on 2021-08-22.
//

import SwiftUI

struct EditView: View {
    @EnvironmentObject var user: User
    var body: some View {
        VStack {
            TextField("Name", text: $user.name)
            NavigationLink(
                destination: DisplayView().environmentObject(user),
                label: {
                    Text("Display View")
                })
        }
       
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
