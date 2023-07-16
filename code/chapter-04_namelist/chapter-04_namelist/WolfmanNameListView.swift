//
//  SymbolListView.swift
//  chapter-04_namelist
//
//  Created by 苏州丰源天下传媒 on 2023/02/26.
//

import SwiftUI

/// 显示花名册列表
struct WolfmanNameListView: View {
    
  let model: WolfManModel
   
  /// 名字列表，来自服务端
  @State var names: [String] = []
  /// 被选择的名字列表
  @State var selected: Set<String> = []
  /// 错误显示
  @State var lastErrorMessage = "" {
    didSet { isDisplayingError = true }
  }
  @State var isDisplayingError = false
  @State var isDisplayingMP = false

    var body: some View {
        NavigationView {
            VStack {
                self.navigationView()
                
                List {
                    Section(
                        content: {
                            if names.isEmpty {
                                ProgressView().padding()
                            }
                            ForEach(names, id: \.self) { name in
                                NameRow(name: name, selected: $selected)
                            }
                            .fontWeight(.medium)
                        },
                        header: self.headerView
                    )
                }
                .listStyle(PlainListStyle())
                .statusBar(hidden: true)
                .toolbar {
                    
                    Button(action: {
                        if !self.selected.isEmpty {
                            self.isDisplayingMP = true
                        }
                    }, label: {
                        Text("魔法值").foregroundColor(selected.isEmpty ? .gray : .green)
                    }).disabled(selected.isEmpty)
                    
                }
                .alert("错误", isPresented: $isDisplayingError, actions: {
                    Button("关闭", role: .cancel) { }
                }, message: {
                    Text(lastErrorMessage)
                })
                .padding(.horizontal)
                .task {
                    guard names.isEmpty else { return }
                    do {
                        names = try await model.nameList()
                    } catch {
                        lastErrorMessage = error.localizedDescription
                    }
                }
            }
        } /// NavigationView
        .background(Color.init(uiColor: .cyan))
    }
      
   func navigationView() -> some View {
       HStack {
           NavigationLink(destination: MagicPointView(selectedNames: Array($selected.wrappedValue).sorted()).environmentObject(model),
                          isActive: $isDisplayingMP) {
             EmptyView()
           }.hidden()
       }
  }
  
  func headerView() -> some View {
     Label(" 狼人花名册", systemImage: "book.circle")
          .foregroundColor(Color(uiColor: .brown))
          .font(.title)
          .padding(.bottom, 20)
  }
}
