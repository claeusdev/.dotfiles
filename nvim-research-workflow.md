# Neovim Research Workflow

This guide explains how to use the Neovim setup in this repository for research-style work:

- Python experiments
- Markdown research notes
- notebook-like execution with Molten
- quick code and note iteration in one editor

This setup does not try to make Neovim into a full notebook GUI. It is built around a better split:

- code and prose live in normal files
- execution happens through Molten
- project runs and tests happen through Overseer and Neotest

---

## 1. The mental model

Use three kinds of buffers:

- `*.py` for reusable code and experiments that may become real modules
- `*.md` for narrative research notes
- `*.ipy` when you want a Python buffer that feels like notebook work but still behaves like code

That split matters.

If something is durable, keep it in Python.
If something is explanatory, keep it in Markdown.
If something is exploratory, use Molten on top of either.

---

## 2. The core notebook keys

The notebook workflow lives under `<leader>m`.

| Key | Action |
| :--- | :--- |
| `<leader>mi` | initialize kernel |
| `<leader>mI` | show Molten info |
| `<leader>me` | evaluate operator |
| `<leader>mv` | evaluate visual selection |
| `<leader>ml` | evaluate line |
| `<leader>mr` | re-evaluate cell |
| `<leader>md` | delete cell |
| `<leader>mo` | show output |
| `<leader>mO` | enter output window |
| `<leader>mH` | hide output |
| `<leader>mn` / `<leader>mp` | next / previous cell |
| `<leader>mx` | interrupt kernel |
| `<leader>mR` | restart kernel |
| `<leader>mX` / `<leader>mL` | export / import output |

This is the center of the research workflow. Memorize it.

---

## 3. Start a research session

A minimal pattern looks like this:

1. Create a project directory.
2. Open a `notes.md`, `scratch.ipy`, or `experiment.py`.
3. Initialize the kernel with `<leader>mi`.
4. Evaluate lines, visual blocks, or cells as you explore.
5. Keep durable code in `*.py` files and explanation in Markdown.

If you are setting up a Python project with `uv`, register the kernel for the environment first using your `jk` fish helper. This config expects that project-level kernel flow.

---

## 4. Choose the right file type

### Markdown

Use Markdown when you want:

- narrative reasoning
- embedded code blocks
- reading notes
- experiment logs
- paper summaries

This config renders Markdown nicely with `render-markdown.nvim`, so headings, bullets, checkboxes, and code blocks are easier to read without leaving normal editing.

### Python

Use Python when you want:

- real modules
- reusable helpers
- functions and tests
- code you expect to keep

### `.ipy`

Use `.ipy` when you want:

- a Python file that still feels like notebook work
- line and cell execution without committing to `.ipynb`
- better compatibility with your normal code tools

In this config, `.ipy` is treated as Python automatically.

---

## 5. A practical Molten loop

The best way to use Molten here is as a short feedback loop.

For example:

1. Write a small function in `scratch.ipy`.
2. Run the current line with `<leader>ml`.
3. Select a block and run it with `<leader>mv`.
4. Open output with `<leader>mo`.
5. Enter the output window with `<leader>mO` if you need to inspect more carefully.
6. Hide it again with `<leader>mH`.

When the kernel gets stuck:

- `<leader>mx` interrupts
- `<leader>mR` restarts

When you want to preserve the session shape:

- `<leader>mX` exports output
- `<leader>mL` imports it later

---

## 6. Use Python project helpers, not ad hoc shelling out

This config has explicit Python task helpers through Overseer.

| Key | Action |
| :--- | :--- |
| `<leader>op` | run current Python file |
| `<leader>oT` | run Python tests |

These helpers detect project roots and prefer `uv run` when the project looks uv-managed. That means you do not need to remember the exact runner every time.

Use these rules:

- use Molten for interactive iteration
- use `<leader>op` for a file as a program
- use `<leader>oT` for tests
- use `<leader>dP` when execution needs a debugger

---

## 7. Search and navigate research work

Research work gets messy quickly unless you search aggressively.

Use:

| Key | Action |
| :--- | :--- |
| `<leader>ff` | find all files |
| `<leader>fr` | reopen recent files |
| `<leader>fg` | grep across notes and code |
| `<leader>f/` | search within the current note |
| `<leader>fs` | jump to symbols in the current file |
| `<leader>ha` | pin active files to Harpoon |

A strong pattern is:

- Harpoon your current note, experiment file, and test file
- use Telescope grep instead of scrolling for old observations

---

## 8. Keep notes and experiments connected

A good research layout inside one repo might look like:

```text
project/
  notes/
    2026-04-02-experiment-log.md
    reading-summary.md
  src/
    baseline.py
    analysis.py
  scratch/
    ideas.ipy
  tests/
    test_baseline.py
```

This config works well with that structure because:

- Oil makes directory work fast
- Telescope makes file switching cheap
- Markdown rendering helps notes stay readable
- Molten keeps execution attached to normal files

---

## 9. A concrete daily research flow

One practical routine:

1. Open the repo.
2. Jump to `notes/today.md` or create it.
3. Open `scratch/session.ipy`.
4. Start the kernel with `<leader>mi`.
5. Try ideas with `<leader>ml` and `<leader>mv`.
6. Move useful code into a real Python module.
7. Run the file or tests with `<leader>op` and `<leader>oT`.
8. Write conclusions in Markdown before ending the session.

That last step matters. The setup is strongest when experiments turn into durable notes and durable code before you close the editor.
