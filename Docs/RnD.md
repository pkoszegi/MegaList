# Research & Discovery

**Purpose:** Document the research and insights that informed the MegaList MVP scope and product decisions.

## Research goals

- Understand how existing list tools support multiple list types
- Identify trade-offs between simplicity and flexibility
- Validate whether categories and light structure are a meaningful differentiator

---

## App evaluations

1. Listonic

What it is optimised for
    - Grocery lists
    - Fast item entry
    - Category-based organisation
    
Strength
    - Strong category model
    - Quick add flow
    - Familiar mental model for shopping lists
    
Limitations
    - Strong grocery bias leaks into other use cases
    - Rigid structure limits reuse for non-shopping lists
    - Feature accretion increases cognitive load over time
    
**Key takeaway:** Categories are valuable, but over-specialisation reduces flexibility

1. Apple Notes

What it is optimised for
    - Basic checklists 
    - Free-form notes
    - Minimal friction for text input
    
Strength
    - Extremely low barrier to entry
    - Flexible content (text, images, tables)
    - System-level reliability
    
Limitations
    - No structured list semantics beyond checklists
    - Categories and grouping require manual organisation
    - Poor scalability for recurring structured lists
    
**Key takeaway:** Flexibility without structure leads to organisational overhead

1. Notion

What it is optimised for
    - Extremely flexible schemas
    - Power users and complex workflows
    
Strength
    - Extremely flexible schemas
    - Powerful sorting and filtering
    - Supports many list-like use cases
    
Limitations
    - High cognitive load
    - Setup cost outweighs benefits for simple lists
    - Overkill for everyday tasks
    
**Key takeaway:** Maximum flexibility comes at a cost of speed and simplicity

---

## Competitive analysis

| App           | Speed of entry    | Structure | Flexibility   | Cognitive load    | Primary use case  |
|---------------|-------------------|-----------|---------------|-------------------|-------------------|
| Apple Notes   | Very high         | Very low  | High          | Low               | Simple checklists |
| Listonic      | High              | Medium    | Low-Medium    | Medium            | Grocery lists     |
| Notion        | Low               | Very high | Very high     | High              | Complex workflows |
| Megalist      | High              | Medium    | Medium        | Low               | Everyday lists    |

---

## Dimension-by-dimension comparison

1. Speed vs configuration
    
Apple Notes
- Zero setup
- No meaningful structure beyond checklists

Listonic
- Fast entry for a specific use case
- Configuration is implicit and opinionated

Notion
- High setup cost before value is realised
- Requires user investment upfront

MegaList
- Fast list creation using predefined list types
- Minimal configuration, structure provided by defaults

**Takeaway:** MegaList prioritises speed without abandoning structure.

2. Structure vs flexibility
    
Apple Notes
- Unstructured content
- Users must invent their own organisation

Listonic
- Strong structure
- Limited adaptability outside groceries

Notion
- Fully custom schemas
- High cognitive overload

MegaList
- Lightweight structure via categories
- Flexibility intentionally constrained to preserve speed

**Takeaway:** MegaList sits between rigid templates and free-form chaos.

3. Cognitive load
    
- Apple Notes: Low, but pushes effort onto the user over time.
- Listonic: Increases as features accumulate
- Notion: High from the first interaction
- MegaList: Progressive disclosure, low upfront demand

**Takeaway:** MegaList optimises for recurring everyday use.

---

## Differentiation summary

Megalist differentiates itself through:
- Supporting multiple list types without over-specialising
- Categories as a first-class organisational primitive
- Deferred complexity rather than upfront configuration
- Maintaining low cognitive overhead

---

## Strategic trade-offs

MegaList intentionally does not compete on:
- Advanced automation
- Deep customisation
- Collaboration (future goal)

These are deferred to protect speed and simplicity in the MVP.

---

## Key insights

- Categories and grouping significantly improve scannability across list types
- Too much configurability increases cognitive load at creation time
- Users benefit from structure that emerges gradually, not upfront
- A single tool can support multiple list types

---

## Implications for MVP

- Categories included in MVP, but limited in scope
- Built-in list types provide structure without configuration
- Advanced features deferred to future iterations


