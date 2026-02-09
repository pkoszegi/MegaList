# MegaList
A list app that is universal but easy to use.

---

## Data Layer

 The app is designed to support multiple types of lists without tying the app to a specific use case. The data layer is built with **SwiftData**.
 
 ---
 
## Models

###MegaList

Represents a list of items.

**Properties:**

`id: UUID` - unique identifier
`title : String` - list title
`template: ListTemplate` - optional template defining extra fields
`items: [MegaItem]` - array of items
`categories: [Category]` - optional, a cached collection of categories used by items in this list

**Notes:**
Every list has an isDone field on its items by default so if template is nil, list is a simple checklist. 
`categories` simplifies the UI for picking categories when adding or editing items.

---

###MegaItem

Represents an individual item in a list.

**Properties:**

`id: UUID`
`name : String`
`isDone: Bool` - default false
`category: Category?` - optional
`fieldValues: [ItemFieldValue]` - values for any extra fields from the template
`parentList: MegaList?` - reference to the list

---

###Category

Represents a category to organize items.

**Properties:**

`id: UUID`
`name : String`
`emoji: String`
`lists: [MegaList]` - all the lists that include items of this category


---

### `ListTemplate` and `TemplateField`

Templates define additional fields for items in a list.  

**ListTemplate Properties:**

`id: UUID`  
`name: String`  
`fields: [TemplateField]`  

**TemplateField Properties:**

`id: UUID`  
`name: String`  
`type: FieldType` — `.boolean`, `.text`, `.number`, `.date`  

**Notes:**  
Templates are immutable once used in a list. Users can create new templates for new types of lists.

---

### `ItemFieldValue`

Stores a value for a template field in an item.  

**Properties:**

`id: UUID`  
`fieldName: String`  
`type: FieldType`  
`boolValue: Bool?`  
`textValue: String?`  
`numberValue: Double?`  
`dateValue: Date?`  

---

## Mock Data

- `MegaItem.samples` — reusable sample items
- `MockData.containerWithSampleData()` — in-memory `ModelContainer` for previews
- Ensures relationships are correctly set to prevent SwiftData crashes
- Sample lists: `Groceries`, `Chores`, `Party Supplies`, `Packing List`

---

## Relationships

- `MegaList` → `MegaItem` (1:N, cascade delete)
- `MegaItem` → `Category` (optional)
- `MegaList` → `ListTemplate` (optional)
- `MegaList` → `ListTemplate` (optional)
- `TemplateField` → `ItemFieldValue` (1:N)

Note: 
There is no direct relationship between `MegaList` and `Category`. A list’s categories are derived from the categories of its items.

---

## Design Decisions

- **Universal approach:** Every item has `isDone` by default, so basic checklists don’t require templates.
- **Extra fields:** Templates define custom fields per list. Items store values using `ItemFieldValue`.
- **Preview safety:** Mock items are “copied” for each list to avoid SwiftData crashes.
- **Categories optional:** Users can leave items uncategorized.
- **Categories are derived from items:** Instead of adding a direct M:N relationship between MegaList and Category, the categories associated with a list are computed by scanning its items. This simplifies the data model while still allowing the UI to show “used” vs “unused” categories for a given list.
