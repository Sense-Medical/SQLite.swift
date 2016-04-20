import XCTest
import SQLite

class FTS5Tests : XCTestCase {

    func test_create_onVirtualTable_withFTS5_compilesCreateVirtualTableExpression() {
        XCTAssertEqual(
            "CREATE VIRTUAL TABLE \"virtual_table\" USING fts5()",
            virtualTable.create(.FTS5())
        )
        XCTAssertEqual(
            "CREATE VIRTUAL TABLE \"virtual_table\" USING fts5(\"string\")",
            virtualTable.create(.FTS5(string))
        )
        XCTAssertEqual(
            "CREATE VIRTUAL TABLE \"virtual_table\" USING fts5(tokenize=simple)",
            virtualTable.create(.FTS5(tokenize: .Simple))
        )
        XCTAssertEqual(
            "CREATE VIRTUAL TABLE \"virtual_table\" USING fts5(\"string\", tokenize=porter)",
            virtualTable.create(.FTS5([string], tokenize: .Porter))
        )
        XCTAssertEqual(
            "CREATE VIRTUAL TABLE \"virtual_table\" USING fts5(tokenize=unicode61 \"removeDiacritics=0\")",
            virtualTable.create(.FTS5(tokenize: .Unicode61(removeDiacritics: false)))
        )
        XCTAssertEqual(
            "CREATE VIRTUAL TABLE \"virtual_table\" USING fts5(tokenize=unicode61 \"removeDiacritics=1\" \"tokenchars=.\" \"separators=X\")",
            virtualTable.create(.FTS5(tokenize: .Unicode61(removeDiacritics: true, tokenchars: ["."], separators: ["X"])))
        )
    }

    func test_match_onVirtualTableAsExpression_compilesMatchExpression() {
        AssertSQL("(\"virtual_table\" MATCH 'string')", virtualTable.match("string") as Expression<Bool>)
        AssertSQL("(\"virtual_table\" MATCH \"string\")", virtualTable.match(string) as Expression<Bool>)
        AssertSQL("(\"virtual_table\" MATCH \"stringOptional\")", virtualTable.match(stringOptional) as Expression<Bool?>)
    }

    func test_match_onVirtualTableAsQueryType_compilesMatchExpression() {
        AssertSQL("SELECT * FROM \"virtual_table\" WHERE (\"virtual_table\" MATCH 'string')", virtualTable.match("string") as QueryType)
        AssertSQL("SELECT * FROM \"virtual_table\" WHERE (\"virtual_table\" MATCH \"string\")", virtualTable.match(string) as QueryType)
        AssertSQL("SELECT * FROM \"virtual_table\" WHERE (\"virtual_table\" MATCH \"stringOptional\")", virtualTable.match(stringOptional) as QueryType)
    }

}
