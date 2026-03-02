# Product Requirements Document

**Pruduct name:** MegaList
**Author:** Petra Koszegi
**Date:** 01-02-2026

MegaList is a lightweight and flexible list creation app, designed for individuals managing multiple everyday lists (e.g. groceries, packing, chores) and want speed, clarity and low cognitive overhead. This PRD is scoped as a portfolio case study to demonstrate product thinking, MVP definition and prioritisation, not to describe a fully polished commercial product.

## Problem Statement

**Observation:** People too often rely on multiple list apps or overloaded note tools to manage everyday tasks.

**Problem to solve:** Most existing list apps are either too simple, just a single checklist or too complex with features that result in user experience friction. How can we help users quickly create and manage flexible lists without overwhelming them with unnecessary features?

---

## Target user

- Individuals managing personal recurring lists
- Frequently maintains 2-5 active lists at any given time
- Comfortable with smartphones, but not necessarily power users
- Value speed, simplicity and reliability

---

## Use Cases

- Weekly grocery shopping list
- Travel packing list
- To-do list for project with tasks and deadlines

---

## Goals

- Enable users to create and edit lists in under 10 seconds
- Support multiple lists without friction
- Keep the UI minimal and focused

---

## Success Criteria

- Clear MVP scope with justified trade-offs
- Working core flows implemented or clearly specified
- Demonstrates product decision making rather than feature volume

---

## Non-Goals

- User accounts / authentication
- Cloud sync or cross-device support
- Collaboration or list sharing
- Reminders, notifications or due dates
- Analytics or productivity metrics

---

## Minimum Viable Product

- Create multiple lists 
- Each list has
    - A name
    - A list type (Grocery / Packing / To-do)
- Add, edit and delete list items
- List items include
    - Title
    - Completion state
    - Category (optional)
- Items can be
    - Grouped by category
    - Marked as completed
- Categories consist of
    - Name
    - Emoji
- Categories can be
    - Selected from categories used in current list
    - Selected from categories not used in current list
    - Created
- Persist data locally on device

---

## Nice-to-have features

- User-defined custom fields per list
- Templates beyond the initial list types
- Arbitrary sorting by custom fields
- Collaborative lists
- Cross-device sync
