# Models

## `MegaList`

Represents a list of items.

**Properties:**

`id: UUID` - unique identifier (`@Attribute(.unique)`)  
`title: String` - list title  
`template: ListTemplate?` - optional template defining extra fields  
`items: [MegaItem]` - list items (`@Relationship(deleteRule: .cascade)`)  
`usedCategories: [Category]` - computed from `items.compactMap(\.category)` (not persisted)

**Notes:**
Every list has an isDone field on its items by default so if template is nil, list is a simple checklist. 
Categories for a list are derived at runtime (`usedCategories`) rather than stored directly on the model.

---

## `MegaItem`

Represents an individual item in a list.

**Properties:**

`id: UUID` (`@Attribute(.unique)`)  
`name: String`  
`isDone: Bool` - default `false`  
`category: Category?` - optional  
`fieldValues: [ItemFieldValue]` - values for template fields (`@Relationship(deleteRule: .cascade)`)  
`parentList: MegaList?` - optional relationship back to the owning list

---

## `Category`

Represents a category to organize items.

**Properties:**

`id: UUID` (`@Attribute(.unique)`)  
`name: String`  
`emoji: String`  

**Note:**  
`Category` currently has no direct relationship property back to `MegaList` or `MegaItem`.

---

## `ListTemplate` and `TemplateField`

Templates define additional fields for items in a list.  

**ListTemplate Properties:**

`id: UUID`  
`name: String`  
`fields: [TemplateField]` (`@Relationship(deleteRule: .cascade)`)  

**TemplateField Properties:**

`id: UUID`  
`name: String`  
`type: FieldType` — `.boolean`, `.text`, `.number`, `.date`  

**Notes:**  
The app also includes built-in templates (`groceries`, `chores`, `packingList`, `projects`) via `BuiltInTemplates`.

---

## `ItemFieldValue`

Stores a value for a template field in an item.  

**Properties:**

`id: UUID`  
`fieldID: UUID`  
`fieldName: String`  
`type: FieldType`  
`boolValue: Bool?`  
`dateValue: Date?`  
`textValue: String?`  
`numberValue: Double?`  

**Note:**  
`ItemFieldValue` stores `fieldID`/`fieldName` snapshots and does not keep a direct SwiftData relationship to `TemplateField`.

---

## Mock Data

- `Category` provides reusable static mock categories (`fruits`, `dairy`, `cleaning`, `bakery`, `drinks`, etc.)
- `MegaItem.samples` — reusable sample items with categories
- `MockData.makeContainer()` — in-memory `ModelContainer` for previews/tests
- `MockData.containerWithSampleData()` — in-memory `ModelContainer` for previews
- Inserts model types: `MegaList`, `Category`, `MegaItem`, `ListTemplate`, `TemplateField`, `ItemFieldValue`
- Sample lists: `Groceries`, `Chores`, `Party Supplies`, `Packing List`
- `Chores` uses `.chores` template and `Packing List` uses `.packingList`

---

## Relationships

- `MegaList` → `MegaItem` (1:N, cascade delete)
- `MegaItem` → `MegaList` via `parentList` (optional back-reference)
- `MegaItem` → `Category` (optional)
- `MegaList` → `ListTemplate` (optional)
- `ListTemplate` → `TemplateField` (1:N, cascade delete)
- `MegaItem` → `ItemFieldValue` (1:N, cascade delete)

---

## Design Decisions

- **Universal approach:** Every item has `isDone` by default, so basic checklists don’t require templates.
- **Extra fields:** Templates define custom fields per list. Items store values using `ItemFieldValue`.
- **Preview safety:** Mock preview data is created as fresh model instances inside an in-memory `ModelContainer`.
- **Categories optional:** Users can leave items uncategorized.
- **Categories are derived from items:** Instead of adding a direct M:N relationship between MegaList and Category, the categories associated with a list are computed by scanning its items. This simplifies the data model while still allowing the UI to show “used” vs “unused” categories for a given list.
