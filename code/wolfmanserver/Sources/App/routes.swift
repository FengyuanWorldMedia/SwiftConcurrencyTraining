import Vapor

func routes(_ app: Application) throws {
    try Test.routes(app)
    try NameList.routes(app)
    try WolfmenImages.routes(app)
    try WolfmenSearchAll.routes(app)
    try WolfmenSearchSuggest.routes(app)
    try WolfmenSearch.routes(app)
}
