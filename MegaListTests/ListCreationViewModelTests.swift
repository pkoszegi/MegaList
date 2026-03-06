import XCTest
import SwiftData
@testable import MegaList

@MainActor
final class ListCreationViewModelTests: XCTestCase {

    func testCanCreate_whenTitleIsEmpty_returnsFalse() async {
        let viewModel = ListCreationViewModel()
        viewModel.title = ""

        XCTAssertFalse(viewModel.canCreate)
    }

    func testCanCreate_whenTitleIsWhitespaceOnly_returnsFalse() async {
        let viewModel = ListCreationViewModel()
        viewModel.title = "   "

        XCTAssertFalse(viewModel.canCreate)
    }

    func testAvailableTemplates_deduplicatesByNormalizedName() async {
        let builtIn = ListTemplate(name: "Groceries", fields: [])
        let customDuplicate = ListTemplate(name: " groceries ", fields: [])
        let customUnique = ListTemplate(name: "Books", fields: [])
        let viewModel = ListCreationViewModel(builtInTemplates: [builtIn])

        let result = viewModel.availableTemplates(customTemplates: [customDuplicate, customUnique])

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.map(\.name), ["Groceries", "Books"])
    }

    func testDidCreateTemplate_setsSelectedTemplateAndHidesSheet() async {
        let viewModel = ListCreationViewModel()
        let template = ListTemplate(name: "Work", fields: [])
        viewModel.showingCreateTemplate = true

        viewModel.didCreateTemplate(template)

        XCTAssertTrue(viewModel.selectedTemplate === template)
        XCTAssertFalse(viewModel.showingCreateTemplate)
    }

    func testCreate_resetsTransientStateAfterInsert() async {
        let container = MockData.makeContainer()
        let context = container.mainContext
        let template = ListTemplate(name: "Travel", fields: [])
        context.insert(template)

        let viewModel = ListCreationViewModel()
        viewModel.title = "Packing"
        viewModel.selectedTemplate = template
        viewModel.showingCreateTemplate = true

        viewModel.create(in: context)

        let descriptor = FetchDescriptor<MegaList>()
        let lists = (try? context.fetch(descriptor)) ?? []

        XCTAssertEqual(lists.count, 1)
        XCTAssertEqual(lists.first?.title, "Packing")
        XCTAssertTrue(lists.first?.template === template)
        XCTAssertEqual(viewModel.title, "")
        XCTAssertNil(viewModel.selectedTemplate)
        XCTAssertFalse(viewModel.showingCreateTemplate)
    }
}
