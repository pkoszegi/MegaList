import XCTest
@testable import MegaList


@MainActor
final class MegaListDetailViewModelTests: XCTestCase {

    func testSortedItems_sortsByCategoryNameThenItemName() async {
        let bakery = Category(name: "Bakery", emoji: "🥐")
        let fruits = Category(name: "Fruits", emoji: "🍎")

        let bread = MegaItem(name: "Bread", category: bakery)
        let banana = MegaItem(name: "Banana", category: fruits)
        let apple = MegaItem(name: "Apple", category: fruits)
        let uncategorized = MegaItem(name: "Uncategorized")

        let viewModel = MegaListDetailViewModel()
        let result = viewModel.sortedItems(from: [banana, bread, uncategorized, apple])

        XCTAssertEqual(result.map(\.name), ["Bread", "Apple", "Banana", "Uncategorized"])
    }

    func testActiveItems_returnsOnlyIncompleteItems() async {
        let list = [
            MegaItem(name: "Done", isDone: true),
            MegaItem(name: "Todo A", isDone: false),
            MegaItem(name: "Todo B", isDone: false)
        ]
        let viewModel = MegaListDetailViewModel()

        let result = viewModel.activeItems(from: list)

        XCTAssertEqual(result.map(\.name), ["Todo A", "Todo B"])
    }

    func testCompletedItems_returnsOnlyCompletedItems() async {
        let list = [
            MegaItem(name: "Done A", isDone: true),
            MegaItem(name: "Todo", isDone: false),
            MegaItem(name: "Done B", isDone: true)
        ]
        let viewModel = MegaListDetailViewModel()

        let result = viewModel.completedItems(from: list)

        XCTAssertEqual(result.map(\.name), ["Done A", "Done B"])
    }

    func testUsedCategories_returnsUniqueSortedCategories() async {
        let fruits = Category(name: "Fruits", emoji: "🍎")
        let bakery = Category(name: "Bakery", emoji: "🥐")
        let items = [
            MegaItem(name: "Banana", category: fruits),
            MegaItem(name: "Bread", category: bakery),
            MegaItem(name: "Apple", category: fruits),
            MegaItem(name: "No Category")
        ]
        let viewModel = MegaListDetailViewModel()

        let result = viewModel.usedCategories(from: items)

        XCTAssertEqual(result.map(\.name), ["Bakery", "Fruits"])
    }
}
