//
//  WolfSearchView.swift
//  chapter-25_search
//
//  Created by 丰源天下传媒 on 2023/5/4.
//

import SwiftUI
 
struct WolfSearchView: View {

  @EnvironmentObject var dataModel: DataModel
  @State private var searchTerm = ""
    
  var body: some View {
      NavigationStack {
          List {
              ForEach(dataModel.nameList) { nameInfo in
                  NavigationLink(destination: Text(nameInfo.desc)) {
                      VStack(alignment: .leading) {
                          Text(nameInfo.name)
                              .font(.title3)
                              .foregroundColor(.gray)
                          HStack {
                              Text("\(nameInfo.id) \(nameInfo.desc)")
                                  .foregroundColor(.green)
                          }
                      }
                  }
              }
          }
          .searchable(text: $searchTerm) {
              ForEach(dataModel.suggestList) { suggest in
                  Text("您要检索 \(suggest.suggest)?").searchCompletion(suggest.suggest)
              }
          }
          .searchScopes($dataModel.searchScope)  {
              ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue)
            }
          }
          .navigationTitle(dataModel.appName)
      }
      .onSubmit(of: .search, runSearch)
      .onChange(of: dataModel.searchScope) { _ in runSearch() }
      .onChange(of: searchTerm) { _ in
          print("searchTerm onChange")
          getSuggest()
      }
      .onAppear() {
          runSearch()
      }
  }

  func runSearch() {
      dataModel.suggestList = []
      if searchTerm.isEmpty {
          Task {
              print("searchTerm.isEmpty")
              let nameList = try? await dataModel.nameList()
              dataModel.nameList = nameList ?? []
          }
      } else {
          Task {
              let nameList = try? await dataModel.searchNameList(keyword: self.searchTerm,
                                                            searchScope: dataModel.searchScope)
              dataModel.searchTermCount[self.searchTerm] = (dataModel.searchTermCount[self.searchTerm] ?? 0) + 1
              dataModel.nameList = nameList ?? []
          }
      }
  }

  func getSuggest() {
      if searchTerm.isEmpty {
          dataModel.suggestList = []
          Task {
              let nameList = try? await dataModel.nameList()
              dataModel.nameList = nameList ?? []
          }
      } else {
          Task {
              let suggestList = try? await dataModel.suggestList(keyword: self.searchTerm)
              dataModel.suggestList = suggestList ?? []
          }
      }
  }
}

struct WolfSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WolfSearchView()
            .environmentObject(DataModel())
    }
}
