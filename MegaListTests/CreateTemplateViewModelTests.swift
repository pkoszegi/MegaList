import XCTest
@testable import MegaList

@MainActor
final class CreateTemplateViewModelTests: XCTestCase {

    func testCanCreate_whenTemplateNameIsEmpty_returnsFalse() async {
        let viewModel = CreateTemplateViewModel()
        viewModel.templateName = "   "

        XCTAssertFalse(viewModel.canCreate)
    }

    func testHasDuplicateTemplateName_isCaseAndWhitespaceInsensitive() async {
        let viewModel = CreateTemplateViewModel()
        viewModel.updateExistingTemplateNames(
            using: [ListTemplate(name: "Groceries", fields: [])]
        )
        viewModel.templateName = "  groceries  "

        XCTAssertTrue(viewModel.hasDuplicateTemplateName)
    }

    func testCanCreate_whenAnyFieldNameIsEmpty_returnsFalse() async {
        let viewModel = CreateTemplateViewModel()
        viewModel.templateName = "My Template"

        XCTAssertFalse(viewModel.canCreate)
    }

    func testCanCreate_whenFieldNamesContainDuplicates_returnsFalse() async {
        let viewModel = CreateTemplateViewModel()
        viewModel.templateName = "My Template"
        viewModel.fields = [
            TemplateFieldDraft(name: "Quantity", type: .number),
            TemplateFieldDraft(name: " quantity ", type: .text)
        ]

        XCTAssertFalse(viewModel.canCreate)
    }

    func testCanAddField_whenExistingFieldsInvalid_returnsFalse() async {
        let viewModel = CreateTemplateViewModel()

        XCTAssertFalse(viewModel.canAddField)
    }

    func testAddField_whenCanAddFieldFalse_doesNotAppend() async {
        let viewModel = CreateTemplateViewModel()
        let initialCount = viewModel.fields.count

        viewModel.addField()

        XCTAssertEqual(viewModel.fields.count, initialCount)
    }

    func testRemoveField_withInvalidOffsets_doesNotCrashOrMutateUnexpectedly() async {
        let viewModel = CreateTemplateViewModel()
        viewModel.fields = [
            TemplateFieldDraft(name: "Field 1", type: .text),
            TemplateFieldDraft(name: "Field 2", type: .number)
        ]
        let initialIDs = viewModel.fields.map(\.id)

        viewModel.removeField(at: IndexSet([99]))

        XCTAssertEqual(viewModel.fields.map(\.id), initialIDs)
    }

    func testRemoveField_whenRemovingAllFields_keepsSingleEmptyDraft() async {
        let viewModel = CreateTemplateViewModel()

        viewModel.removeField(at: IndexSet([0]))

        XCTAssertEqual(viewModel.fields.count, 1)
        XCTAssertEqual(viewModel.fields[0].name, "")
        XCTAssertEqual(viewModel.fields[0].type, .text)
    }
}
