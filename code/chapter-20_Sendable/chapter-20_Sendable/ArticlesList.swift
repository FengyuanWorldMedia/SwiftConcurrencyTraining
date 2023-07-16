//
//  test.swift
//  chapter-20_Sendable
//
//  Created by 丰源天下传媒 on 2023/4/23.
//

import Foundation
public struct Article {
    internal var title: String
}

actor ArticlesList {
    func filteredArticles(_ isIncluded: @Sendable (Article) -> Bool) async -> [Article] {
        return []
    }
}

func test() async {
    let listOfArticles = ArticlesList()
    let searchKeyword: NSAttributedString? = NSAttributedString(string: "keyword")

    _ = await listOfArticles.filteredArticles { article in
        return article.title == searchKeyword!.string
    }
}
