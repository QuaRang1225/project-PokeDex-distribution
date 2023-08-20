//
//  TestView.swift
//  PokeDex_Project
//
//  Created by 유영웅 on 2023/08/19.
//

import SwiftUI

struct TestView: View {
    @StateObject var vm = MoveSaveViewModel()
    var body: some View {
        VStack{
            
        }.task{
             vm.getItemList()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
