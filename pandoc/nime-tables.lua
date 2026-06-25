-- nime-tables.lua — render Markdown tables as acmart-friendly floats.
--
-- Pandoc's LaTeX writer emits `longtable` for every table, but longtable does
-- not work in two-column mode (the NIME `sigconf` paper format), failing with
-- "longtable not in 1-column mode". This filter converts each table into a
-- standard `table` + `tabular` float with booktabs rules, matching the LaTeX
-- templates. Cell contents are rendered through pandoc so inline formatting
-- (bold, emphasis, maths, citations, ...) is preserved.

local ALIGN = {
  AlignLeft = "l",
  AlignCenter = "c",
  AlignRight = "r",
  AlignDefault = "l",
}

-- Render a list of blocks (a cell's contents) to a trimmed LaTeX string.
local function render_cell(blocks)
  local s = pandoc.write(pandoc.Pandoc(blocks), "latex")
  return (s:gsub("%s+$", ""))
end

local function render_row(row)
  local parts = {}
  for _, cell in ipairs(row.cells) do
    parts[#parts + 1] = render_cell(cell.contents)
  end
  return table.concat(parts, " & ") .. " \\\\"
end

local function rows_of(body)
  -- A TableBody has intermediate-head rows (.head) plus body rows (.body).
  local out = {}
  for _, r in ipairs(body.head) do out[#out + 1] = r end
  for _, r in ipairs(body.body) do out[#out + 1] = r end
  return out
end

function Table(t)
  -- Column alignment string, e.g. "lcr".
  local colspec = {}
  for _, c in ipairs(t.colspecs) do
    colspec[#colspec + 1] = ALIGN[c[1]] or "l"
  end
  colspec = table.concat(colspec)

  local lines = {}
  lines[#lines + 1] = "\\begin{table}[htbp]"

  local caption = render_cell(t.caption.long or {})
  if caption ~= "" then
    lines[#lines + 1] = "  \\caption{" .. caption .. "}"
  end
  if t.attr and t.attr.identifier and t.attr.identifier ~= "" then
    lines[#lines + 1] = "  \\label{" .. t.attr.identifier .. "}"
  end

  lines[#lines + 1] = "  \\begin{tabular}{" .. colspec .. "}"
  lines[#lines + 1] = "  \\toprule"

  -- Header rows.
  local had_header = false
  for _, r in ipairs(t.head.rows) do
    lines[#lines + 1] = "  " .. render_row(r)
    had_header = true
  end
  if had_header then
    lines[#lines + 1] = "  \\midrule"
  end

  -- Body rows (across all table bodies).
  for _, body in ipairs(t.bodies) do
    for _, r in ipairs(rows_of(body)) do
      lines[#lines + 1] = "  " .. render_row(r)
    end
  end

  lines[#lines + 1] = "  \\bottomrule"
  lines[#lines + 1] = "  \\end{tabular}"
  lines[#lines + 1] = "\\end{table}"

  return pandoc.RawBlock("latex", table.concat(lines, "\n"))
end
