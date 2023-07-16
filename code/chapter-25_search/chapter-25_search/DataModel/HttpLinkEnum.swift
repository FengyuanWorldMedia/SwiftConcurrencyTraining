//
//  HttpLinkEnum.swift
//  chapter-25_search
//
//  Created by 丰源天下传媒 on 2023/5/4.
//

import Foundation

public enum HttpLinkEnum: String {
    public typealias RawValue = String
    #if DEBUG
        case NameList = "http://127.0.0.1:8080/search/names"
        case SuggestList = "http://127.0.0.1:8080/search/suggest"
        case SearchNameList = "http://127.0.0.1:8080/search/searchname"
    #elseif RELEASE
        case NameList = "http://127.0.0.1:8080/search/names"
        case SuggestList = "http://127.0.0.1:8080/search/suggest"
        case SearchNameList = "http://127.0.0.1:8080/search/searchname"
    #endif
    case None = ""
}
