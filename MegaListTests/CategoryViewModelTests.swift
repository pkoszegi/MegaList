import XCTest
@testable import MegaList

@MainActor
final class CategoryViewModelTests: XCTestCase {

    func testAddCategoryCanCreate_requiresNonEmptyNameAndEmoji() async {
        let viewModel = AddCategoryViewModel(usedEmojis: [])

        XCTAssertFalse(viewModel.canCreate)

        viewModel.name = "Snacks"
        XCTAssertFalse(viewModel.canCreate)

        viewModel.emoji = "🍿"
        XCTAssertTrue(viewModel.canCreate)
    }

    func testAddCategoryAvailableEmojis_excludesUsedEmojis() async {
        let used = Set(["🍎", "🥦"])
        let viewModel = AddCategoryViewModel(usedEmojis: used)

        XCTAssertFalse(viewModel.availableEmojis.contains("🍎"))
        XCTAssertFalse(viewModel.availableEmojis.contains("🥦"))
        XCTAssertEqual(viewModel.availableEmojis.count, EmojiRepository.defaults.count - used.count)
    }

    func testCategoryPickerIsDuplicate_matchesByNameCaseInsensitiveOrEmoji() async {
        let existing = Category(name: "Snacks", emoji: "🍿")
        let viewModel = CategoryPickerViewModel(
            usedCategories: [],
            allCategories: [existing]
        )

        let sameName = Category(name: "snacks", emoji: "🥨")
        let sameEmoji = Category(name: "Party", emoji: "🍿")
        let unique = Category(name: "Books", emoji: "📚")

        XCTAssertTrue(viewModel.isDuplicate(sameName))
        XCTAssertTrue(viewModel.isDuplicate(sameEmoji))
        XCTAssertFalse(viewModel.isDuplicate(unique))
    }
}
