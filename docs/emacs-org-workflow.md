# Emacs Org Workflow

This document explains how to use the Org side of the Emacs setup in this repository for:

- inbox capture
- tasks
- project notes
- research notes
- paper tracking
- daily notes
- citations
- writing

This config is built around:

- `org`
- `org-roam`
- `citar`
- `org-noter`
- `org-download`
- `org-present`

If you are setting this up on a new machine, run `C-c e h` first. It will tell you whether the optional PDF, citation, and language tools this workflow expects are actually available.

---

## 1. The mental model

Think of the Org setup as having several layers.

### Operational layer

Files in `~/org/`:

- `inbox.org`
- `projects.org`
- `papers.org`
- `journal.org`

If these files or directories do not exist yet, this config bootstraps the basic structure automatically on startup.

These are for:

- quick capture
- active work
- agenda views
- daily operational planning

### Knowledge layer

Files in `~/org/roam/`

These are for:

- durable notes
- topic notes
- project knowledge
- literature notes
- daily notes

### Reference layer

Files in:

- `~/org/references.bib`
- `~/org/pdfs/`

These are for:

- bibliography entries
- PDFs
- citation-driven note-taking

This separation matters:

- `~/org/` is where active task management lives.
- `~/org/roam/` is where long-lived knowledge lives.

---

## 2. The most important Org commands

| Key | Action |
| :--- | :--- |
| `C-c c` | Capture |
| `C-c a` | Agenda |
| `C-c n f` | Find org-roam node |
| `C-c n I` | Insert org-roam node link |
| `C-c n d` | Open today’s daily note |
| `C-c n i` | Open inbox |
| `C-c n p` | Open projects file |
| `C-c n P` | Open papers file |
| `C-c n j` | Open journal file |
| `C-c n l` | Find literature notes |
| `C-c n s` | Search Org and org-roam notes |
| `C-c b i` | Insert citation |
| `C-c b o` | Open citation entry |
| `C-c b n` | Open citation notes |
| `C-c N` | Start org-noter |

If you only memorize five things, memorize:

- `C-c c`
- `C-c a`
- `C-c n f`
- `C-c n d`
- `C-c n s`

---

## 3. Capture tasks and ideas quickly

The most important entry point is:

- `C-c c`

This opens the capture menu.

Current templates include:

- `t` Todo
- `i` Idea
- `p` Project task
- `R` Paper
- `j` Journal

The defaults are intentionally structured:

- inbox captures land in stable top-level headings
- project captures create a `NEXT` task plus a notes subtree
- paper captures create a reading task with space for why it matters and notes
- dailies start with `Plan`, `Log`, and `Reading` headings

### Typical task capture

Suppose you are coding and realize:

- you need to fix a bug later
- you should read a paper
- you have an idea worth saving

Do not leave the current file mentally. Capture it immediately.

Example flow:

1. Press `C-c c`
2. Press `t`
3. Type the task
4. Finalize capture

The task goes into `~/org/inbox.org`.

This is the central habit that makes Org useful: capture immediately, organize later.

---

## 4. Use the agenda as your control center

Open the agenda with:

- `C-c a`

This setup includes custom agenda commands:

- `d` Dashboard
- `i` Inbox
- `p` Projects
- `r` Research
- `w` Writing

### Dashboard view

Use the dashboard when starting the day.

It is meant to show:

- today’s schedule
- next actions
- research-tagged tasks
- coding-tagged tasks

### Why this matters

Without the agenda, Org becomes a pile of files.

With the agenda, Org becomes a working system.

A practical routine:

1. Start Emacs.
2. Open `C-c a`.
3. Choose dashboard.
4. Decide what the next meaningful task is.
5. Jump into code or writing from there.

---

## 5. Manage project work in Org

Use:

- `C-c n p` to open `projects.org`
- `C-c n P` to open `papers.org`
- `C-c n j` to open `journal.org`

This file is for active, operational project planning:

- next tasks
- checkpoints
- delivery notes
- links to code, tickets, or docs

### Suggested structure

```org
* Active
** Project Alpha
*** NEXT Add authentication tests
*** TODO Refactor config loading
** Project Beta
*** WAIT Review experiment results
```

The goal is not to make this beautiful. The goal is to make project state obvious.

---

## 6. Search your notes

Use:

- `C-c n s`

This searches both:

- `~/org/`
- `~/org/roam/`

Use it constantly.

Good examples:

- search a person’s name
- search a theorem or concept
- search a paper title fragment
- search a project codename
- search `TODO`

This is the fastest way to recover information when you remember content but not file location.

---

## 7. Use org-roam for durable knowledge

Use:

- `C-c n f` to find or create a node
- `C-c n I` to insert a link to a node from another note
- `C-c n c` to capture into a new node
- `C-c n b` to toggle the backlinks buffer

### What belongs in org-roam

Put long-lived knowledge here:

- language notes
- architecture notes
- concept explanations
- literature notes
- meeting summaries worth keeping
- project reference notes

Do not use org-roam for every tiny temporary task. Keep quick operational items in inbox/projects files.

### Current capture templates

The config supports:

- default note
- project note
- literature note

Each template now starts with a stronger skeleton:

- default notes start with a `Summary` section
- project notes start with `Context`, `Next Actions`, and `References`
- literature notes start with `Summary`, `Notes`, and `Quotes`

That means you can deliberately separate:

- general notes
- project knowledge
- paper-driven notes

---

## 8. Literature and paper workflow

This setup is explicitly built for academic and research-style reading.

Core tools:

- `citar`
- `citar-org-roam`
- `org-noter`
- `pdf-tools`

### Basic paper workflow

Assume you have:

- a BibTeX entry in `~/org/references.bib`
- the PDF stored under `~/org/pdfs/`

Now do the following:

1. Capture the paper task with `C-c c` then `R`.
2. Open a literature note with `C-c n l` or create one with roam capture.
3. Insert the citation with `C-c b i`.
4. Open the reference or file with `C-c b o`.
5. Start note-taking next to the PDF with `C-c N`.

### Why org-noter matters

`org-noter` lets you read a PDF and keep structured notes alongside it.

That is useful when:

- reading a paper carefully
- annotating a technical report
- taking notes from lecture PDFs
- building literature summaries

### A realistic paper-note flow

1. Add paper metadata to the bibliography.
2. Place PDF in `~/org/pdfs/`.
3. Create or open a literature note.
4. Insert a citation to anchor the note.
5. Launch `org-noter`.
6. Take section-by-section notes.
7. Later, use `C-c n s` to rediscover those notes by content.

---

## 9. Use daily notes

Open today’s note with:

- `C-c n d`

The daily template starts with:

- `Plan`
- `Log`
- `Reading`

This is useful for:

- daily planning
- work logs
- reading notes
- quick scratch notes that might later become permanent

Do not overthink the daily note. It is allowed to be messy.

A good use pattern:

- morning: write the day’s plan
- during work: drop small notes and decisions
- evening: convert anything important into proper project or roam notes

---

## 10. Use Org for writing

This config already enables:

- `visual-line-mode`
- `org-superstar`
- `writegood-mode`
- `jinx`
- `org-src-fontify-natively`
- `org-src-tab-acts-natively`

That means Org is comfortable for:

- technical notes
- outlines
- papers
- literate documentation
- meeting notes

### Writing with source blocks

Org Babel is enabled for:

- Emacs Lisp
- Python
- shell
- LaTeX

So you can write documents like:

```org
* Experiment

Here is the quick calculation:

#+begin_src python
print(sum(i * i for i in range(5)))
#+end_src
```

When executed, source blocks become part of a literate workflow rather than separate scratch scripts.

### Safety note

This config only skips confirmation for trusted Babel languages:

- `emacs-lisp`
- `python`
- `latex`

Other languages still require confirmation.

---

## 11. Refile and organize later

The setup is designed so you can capture quickly first and organize later.

That means this is normal:

1. Capture into inbox.
2. Review later in agenda or inbox.
3. Refile into projects or roam.

This is better than trying to choose the perfect destination during every interruption.

---

## 12. A full research-oriented Org workflow

Here is a realistic flow for a researcher or engineer.

### Morning planning

1. `C-c a`
2. Open dashboard
3. Review `NEXT` tasks
4. Open today’s daily note with `C-c n d`
5. Write a plan for the day

### During coding

1. Notice a follow-up task
2. `C-c c`, then `t`
3. Return to code immediately

### During reading

1. Open or create a literature note
2. Open the paper PDF
3. Use `C-c N` for linked notes
4. Insert citations where needed

### During idea generation

1. `C-c c`, then `i`
2. Save the idea into inbox
3. Later promote it into a project note or roam note if it proves useful

### End of day

1. Review inbox
2. Refile items into projects or literature notes
3. Update task states
4. Leave tomorrow’s first next action visible

That is the intended researcher/SWE loop for this setup.

---

## 13. Recommended habits for Org in this config

If you want Org to stay useful instead of turning into clutter:

- capture first, organize later
- search notes with `C-c n s` instead of manually browsing folders
- keep tasks in `~/org/`
- keep durable knowledge in `~/org/roam/`
- use daily notes for messy short-lived context
- use literature notes for papers, not generic inbox entries
- review agenda regularly

The system works when capture is low-friction and review is consistent.

---

## Short Reference

| Key | Action |
| :--- | :--- |
| `C-c c` | Capture |
| `C-c a` | Agenda |
| `C-c n i` | Open inbox |
| `C-c n p` | Open projects |
| `C-c n d` | Today’s daily note |
| `C-c n f` | Find org-roam node |
| `C-c n l` | Find literature notes |
| `C-c n s` | Search notes |
| `C-c b i` | Insert citation |
| `C-c b n` | Open citation notes |
| `C-c N` | Start org-noter |

## Final advice

Use this setup as a working system rather than a pile of files.

That means:

- capture instead of remember
- search instead of browse
- separate active tasks from long-lived knowledge
- keep papers, notes, and citations connected
- review agenda and inbox regularly

That is where the Org side of the configuration becomes much more valuable than plain notes in random files.
