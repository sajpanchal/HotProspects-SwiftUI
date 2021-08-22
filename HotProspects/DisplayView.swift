//
//  DisplayView.swift
//  HotProspects
//
//  Created by saj panchal on 2021-08-22.
//

import SwiftUI

struct DisplayView: View {
    @EnvironmentObject var user: User
    var body: some View {
        Text(user.name)
    }
}

struct DisplayView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayView()
    }
}
