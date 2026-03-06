import XCTest
import SwiftData
import SwiftUI
@testable import MegaList


@MainActor
final class AddItemViewModelTests: XCTestCase {

    func testCanCreate_whenNameIsWhitespaceOnly_returnsFalse() async {
        let list = MegaList(title: "Groceries")

        let viewModel = AddItemViewModel(list: list)
        viewModel.name = "   "

        XCTAssertFalse(viewModel.canCreate)
    }
    
    func testUsedCategories_returnsUniqueCategoriesFromListItems() async {
        let fruits = Category(name: "Fruits", emoji: "🍎")
        let dairy = Category(name: "Dairy", emoji: "🧀")
        let list = MegaList(title: "Groceries")
        
        list.items = [
            MegaItem(name: "Apple", category: fruits),
            MegaItem(name: "Banana", category: fruits),
            MegaItem(name: "Milk", category: dairy),
            MegaItem(name: "Bread")
        ]

        let viewModel = AddItemViewModel(list: list)
        let categories = viewModel.usedCategories

        XCTAssertEqual(categories.count, 2)
        XCTAssertTrue(categories.contains(where: { $0 === fruits }))
        XCTAssertTrue(categories.contains(where: { $0 === dairy }))
    }

    func testAddItem_setsParentListAndSelectedCategory() async {
        let container = MockData.makeContainer()
        let context = container.mainContext
        let list = MegaList(title: "Groceries")
        let category = Category(name: "Fruits", emoji: "🍎")
        context.insert(list)
        context.insert(category)

        let viewModel = AddItemViewModel(list: list)
        viewModel.name = "Apple"
        viewModel.selectedCategory = category

        viewModel.addItem(in: context)

        XCTAssertEqual(list.items.count, 1)
        XCTAssertEqual(list.items[0].name, "Apple")
        XCTAssertTrue(list.items[0].parentList === list)
        XCTAssertTrue(list.items[0].category === category)
    }

    func testAddItem_persistsFieldValuesFromFieldController() async {
        let container = MockData.makeContainer()
        let context = container.mainContext
        let templateField = TemplateField(name: "Quantity", type: .number)
        let template = ListTemplate(name: "Groceries", fields: [templateField])
        let list = MegaList(title: "Groceries", template: template)
        context.insert(template)
        context.insert(list)

        let viewModel = AddItemViewModel(list: list)
        viewModel.name = "Apples"
        viewModel.fieldController.numberTextBinding(for: templateField).wrappedValue = "2"

        viewModel.addItem(in: context)

        XCTAssertEqual(list.items.count, 1)
        XCTAssertEqual(list.items[0].fieldValues.count, 1)
        XCTAssertEqual(list.items[0].fieldValues[0].fieldName, "Quantity")
        XCTAssertEqual(list.items[0].fieldValues[0].numberValue, 2)
    }
}
