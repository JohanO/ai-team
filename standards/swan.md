# SWAN Principle

SWAN = Simplest Working Approach Now

Solve today's problem with the simplest approach that works. Do not build for hypothetical futures.

SWAN is the practical check for the "Simplicity First" principle in [architecture.md](architecture.md). Both apply.

## The Check

Before proposing a solution, ask:

1. Does it solve today's problem?
2. Is there a simpler way?
3. Are we introducing abstractions without multiple use cases?
4. Can we easily change this later?

Then act on the answers:

- If (1) is no, stop and clarify the problem first.
- If (2) is yes, choose the simpler option.
- If (3) is yes, remove the abstraction. Abstract on the third real use, not the first.
- If (4) is no, slow down. Hard-to-reverse decisions (data models, public APIs, security boundaries, external contracts) deserve a fuller analysis. Easy-to-change decisions get the simple option.

When in doubt, SWAN.

## What SWAN Does Not Mean

SWAN reduces speculative scope. It never lowers quality. It does not override:

- Correctness
- Security
- Accessibility
- Testing standards
- Documented decisions the team has already made

"Now" means "what is needed now", not "quick and dirty". Skipping tests, validation, or accessibility is not simpler. It is deferred cost.

## Example

Need: send a welcome email after sign-up.

- Over-engineered: an `INotificationChannel` interface, a factory, and a plugin registry for a future SMS channel nobody asked for.
- SWAN: one `sendWelcomeEmail(user)` function. If SMS is requested later, extract the abstraction then, with two real use cases to guide its shape.

## Reporting

Personas that propose or review solutions (Tina, Alice, Bob, Rita) end their answer with one line:

> **SWAN check:** <what was kept simple, or which complexity is justified and why>

Rita treats an unjustified abstraction or speculative feature as a Major finding.
