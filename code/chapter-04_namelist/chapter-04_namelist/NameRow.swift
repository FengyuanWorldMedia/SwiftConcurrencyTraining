//
//  SymbolRow.swift
//  chapter-04_namelist
//
//  Created by 苏州丰源天下传媒 on 2023/02/26.
//


import SwiftUI

struct NameRow: View {
  let name: String
  @Binding var selected: Set<String>
 
  @State var selectedFlg = false
    
  var body: some View {
    Button(action: {
        // print(selectedFlg)
        if !selectedFlg {
            selected.insert(name)
        } else {
            selected.remove(name)
        }
        selectedFlg = !selectedFlg
        // print(selected)
    }, label: {
        self.nameRowView()
    })
  }
    
  func nameRowView() -> some View {
        HStack {
          HStack {
            if selectedFlg {
              Image(systemName: "person.fill.checkmark")
                    .foregroundColor(.green)
            } else {
              Image(systemName: "person.fill")
            }
          }
          .frame(width: 20)
           if selectedFlg {
               Text(name)
                 .fontWeight(.bold)
                 .foregroundColor(.green)
           } else {
              Text(name)
                .fontWeight(.regular)
           }
        }
   } 
}
