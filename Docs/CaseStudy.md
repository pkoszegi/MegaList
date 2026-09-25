# Case Study

**Project:** MegaList
**Type:** iOS app (SwiftUI)
**Duration:** 8 weeks
**Role:** Solo designer & developer

MegaList is a lightweight and flexible list creation app, designed for individuals managing multiple everyday lists (e.g. groceries, packing, chores) who want speed, clarity and low cognitive overhead. It differentiates itself through a balance of simplicity and flexibility. I built it with the purpose of creating this case study.

## The Problem

Most list apps fall into two extremes:
- Too simple -> only checklists
- Too complex -> heavy task managers with rigid structures

I wanted to explore whether it was possible to build a single flexible list system that could handle:
- Groceries
- Chores
- Packing lists
- Project trackers
- Custom structured lists

The challenge:
How do you design a data layer that supports multiple list types without hardcoding each use case into it or turning the app a schema nightmare?

## Goals

- Support simple checklists by default
- Categories are part of the model but optional for items
- Allow structured lists with custom fields
- Avoid creating a new model type for every list type
- Keep SwiftData relationships clean and maintainable

Non-Goals
- Cloud sync
- Collaboration
- Enterprise task management

## Product Principles

Several guiding principles shaped the design of MegaList.

**Speed over configuration**
Users should be able to create and start using a list immediately. Time-to-first-item is prioritized over advanced configuration.

**Structure without complexity**
Lists provide lightweight structure through templates and categories, but avoid becoming complex database-like systems.

**Constraints improve usability**
Customization is intentionally limited to prevent cognitive overload and keep the interface focused.

**Lists are independent contexts**
Each list acts as its own environment. Categories, fields, and behaviors remain scoped to the list that uses them.

## Key Architectural Decisions

**1. Template-Driven Items**

Instead of creating separate models like
- GroceryItem
- ChoreItem
- PackingItem

I introduced:
- ListTemplate
- TemplateField
- ItemFieldValue

When a user creates a list, they can optionally use default templates or create custom templates with up to 3 custom fields. Each item stores values for those fields.

**Why?**

This makes the system:
- Extensible without schema changes
- Flexible per list
- Future-proof for custom user templates

The alternative would have required:
- Multiple item models
- Conditional UI logic
- Schema migrations for every new list type

**2. Every Item is Completable**

I kept `isDone` in `MegaItem` regardless of the template, because checklists are the lowest common denominator of list apps.

**Why?**

If a list has no template, it becomes a simple checklist automatically. This prevents:
- Template-required complexity
- Duplicate checklist models
- UI branching for basic lists

It keeps the mental model simple, every list item can always be checked off.

**3. Categories are Derived, Not Related**

Instead of creating a direct many-to-many relationship between `MegaList` and `Category`, categories are derived at runtime from items.

**Why?**
- Avoid redundant relationship maintenance
- Prevent data inconsistency
- Reduce SwiftData relationship complexity
- Keep categories optional

This is a deliberate tradeoff:
- Slight runtime computation
- Much simpler persistence model

I chose simplicity over premature optimization.


**4. MVVM Architecture**

I chose to have Model, View, and ViewModel layers.

**Why?**
- SwiftUI is declarative and state-driven
- SwiftData models integrate naturally with observable state
- Separating view logic from data mutations improves testability

ViewModels are responsible for
- Item mutations
- Template application logic
- Category filtering

This prevents:
- Business logic inside Views
- Overuse of computed properties inside models

Tradeoff:
- Slightly more boilerplate and additional layer to maintain
- Keeps architecture scaleable as features grow

## What This Project Demonstrates

- Designing flexible data models without schema fragmentation
- Practical SwiftData relationship design and tradeoffs
- Template-driven UI generation in SwiftUI
- Balancing product flexibility with cognitive load

## UX Issues I Encountered


**1. Flexibility vs simplicity**

Earlier versions allowed unlimited custom fields.

Problem:
- UI became visually dense
- Item creation felt slow
- Cognitive load increased

Resolution:
- Limited custom templates to 3 fields maximum
- Prioritized speed over flexibility
- Kept the primary interaction focused on checking items off

Tradeoff:
- Less power
- More clarity

**Optional Categories in the UI**

Originally categories were always visible in the UI.

Problem:
- Empty categories cluttered the interface
- Users had to manage categories even if they didn't care about them

Resolution:
- Categories are optional
- Lists only surface categories that are actually used

Tradeoff:
- Users might not be aware of the flexibility of lists
- Serves users who want simple checklists

**Numeric field input behavior**

Originally number fields were bound directly to a non-optional `Double` with a default value of `0`.

Problem:
- When creating a new item with a numeric field, the value was already `0`
- In SwiftUI `TextField` treats `0` as a real content rather than a placeholder
- When user typed `2`, the field would become `20`

Resolution:
- Instead of binding to a `Double`, the field is bound to a `String`
- The text input is then parsed to a `Double` when saved

Tradeoff:
- Less native numeric field behavior
- Slightly more parsing logic
- Clearer UX during item creation and editing

**Template field deletion behavior**

Originally users could add multiple custom fields when creating a template.

Problem:
- Users could add a second custom field without filling out the first
- Deleting the second field could trigger an index out of range error because the UI state assumed the previous field was valid

Resolution:
- Prevent adding a new field until the previous field is completed
- Add validation to ensure template fields have a valid name and type before allowing additional fields
- Improve deletion handling so UI state cannot reference invalid indices

Tradeoff:
- Slightly less flexible editing flow
- More robust state management and predictable UI behavior

## Testing

**Test Coverage**
- List creation validation and template selection behavior
- Template creation validation rules
- Item creation behavior
- List detail filtering/sorting logic
- Category validation and duplicate detection logic

**Test Strategy**
- Most tests focus on ViewModel and model logic and avoid persistence setup
- Where persistance behavior is involved, tests use an in-memory mock container
- SwiftUI view rendering details were not directly unit tested
- Views are declarative in this project, so correctness is validated by testing the state and logic that drive them, plus manual UI verification for interaction polish

## Development Process

AI-assisted tools were used as a supplementary resource during development.

ChatGPT was primarily used for 
- architectural brainstorming 
- exploring alternative approaches to the template and data model design

Codex was used 
- during implementation of the dynamic template field system (particularly bindings for item field values)
- for generating initial unit test scaffolding
- minor bug fixes and code cleanup

All final architectural decisions, debugging, and integration were performed and verified manually.

## What I Would Improve

- Cloud sync for persistence and collaboration
- Templates could support constrained value sets (e.g. enum-style fields such as priority: low / medium / high).
- Lists could support sorting items by template field values (e.g. by date, priority or numeric values).
- UX onboarding
- Future versions could include a dedicated template management interface allowing users to inspect, edit, and create templates.

## Key Takeaways

Building MegaList highlighted several product and engineering lessons.

**Flexibility requires boundaries**
Early versions allowed highly customizable templates with unlimited fields. While technically flexible, this increased cognitive load and slowed down item creation. Limiting templates to a small number of fields created a faster and clearer user experience.

**Architecture should reflect product intent**
The template system allowed different list types to share a common data model without introducing separate item types. This avoided schema fragmentation while still supporting structured lists.

**Physical-device testing surfaces real issues sooner**
Several interaction bugs only appeared when testing on a real device, particularly around text input and editing flows. This reinforced that testing only on simulator is insufficient for interaction-heavy SwiftUI interfaces.

**Simple data models reduce long-term maintenance cost**
Deriving categories from items avoided maintaining an additional many-to-many relationship. This small runtime computation significantly simplified the persistence layer and reduced the risk of inconsistent data.

**UX issues often emerge during implementation rather than planning**
Problems such as numeric field input behavior or template field deletion errors only became visible during implementation. Iterative testing during development proved essential for catching these issues early.

**Building generic systems introduces hidden complexity**
Designing a single data model that supports multiple list types required careful tradeoffs between flexibility and simplicity. While templates enabled reuse, they also introduced additional validation and UI complexity that would not exist in a single-purpose list app.
