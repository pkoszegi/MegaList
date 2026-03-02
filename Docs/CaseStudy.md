# Case Study

**Project:** MegaList
**Type:** iOS app (SwiftUI)
**Duration:** 8 weeks
**Role:** Solo designer & developer

MegaList is a lightweight and flexible list creation app, designed for individuals managing multiple everyday lists (e.g. groceries, packing, chores) and want speed, clarity and low cognitive overhead. It can be differentiated from other similar apps, because of it's simplicity and flexibility. I built it with the purpose of creating this case study.

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

---

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

---

## Key Architectural Decisions

## 1. Template-Driven Items

Instead of creating separate models like
- GroceryItem
- ChoreItem
- PackingItem

I introduced:
- ListTemplate
- TemplateField
- ItemFieldValue

When user creates a list, they can optionally use default templates or create custom templates with up to 3 custom fields. Each item stores values for those fields.

**Why?**

This makes the system:
- Extensible without schema changes
- Flexible per list
- Future-proof for custom user templates

The alternative would have required:
- Multiple item models
- Conditional UI logic
- Schema migrations for every new list type

## 2. Every Item is Completable

I kept `isDone` in `MegaItem` regardless of the template, because checklists are the lowest common denominator of list apps.

**Why?**

If a list has no template, it becomes a simple checklist automatically. This prevents:
- Template required complexity
- Duplicate checklist models
- UI branching for basic lists

It keeps the mental model simple, every list item can always be checked off.

## 3. Categories are Derived, Not Related

Instead of creating a direct many-to-many relationship between `MegaList` and `Category` I derive categories at runtime from items.

**Why?**
- Avoid redundant relationship maintanance
- Prevent data inconsistency
- Reduce SwiftData relationship complexity
- Keep categories optional

This is a deliberate tradeoff:
- Slight runtime computation
- Much simpler persistence model

I chose simplicity over premature optimization.


## 4. MVVM Architecture

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

---

## What This Project Demonstrates

- Flexibility must be constrained to maintain usability
- SwiftData relationship design
- Template-driven architecture
- Features increase cognitive load

---

## UX Issues I Encountered


## 1. Flexibility vs simplicity

Earlier versions allowed unlimited custom fields

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

## Categories on UI

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

TODO

---

## Testing

TODO

---

## What I Would Improve

- Cloud sync for persistence and collaboration
- Smarter template validation
- UX onboarding

TODO

---

## Key Takeaways

TODO

