---
name: add-quarterly-report
description: Bring the accounting page of adaptiv.se in line with the quarterly income statements (Resultatrapport PDFs) in assets/pdf/accounting - enter the figures of new reports in _data/accounting.yml so the charts and the list of links include them, and keep only the eight latest quarters. Use this whenever the user has added or mentions a new quarterly report, kvartalsrapport, resultatrapport or resultaträkning, asks to update the accounting page or "redovisningen", or asks why a quarter is missing from the charts, even if they only say "jag har lagt in en ny rapport".
---

# Add a quarterly report

The page `/accounting/` shows two charts and a list of links to the report PDFs, all drawn from `_data/accounting.yml`. The PDFs in `assets/pdf/accounting/` are the source: the user puts a new report there, and this skill makes the data follow. The data holds the eight latest quarters and nothing else, so the page stays short.

The charts and the PDF they link to must show the same figures, so every number comes from the PDF and is checked before it is written.

## 1. Find the eight latest reports

List `assets/pdf/accounting/`. The files are named `Resultatrapport_YYYYMMDD-YYYYMMDD_Adaptiv_Sthlm_AB.pdf` (some have a double underscore after "Resultatrapport"; use the names as they are). Sort by the period in the name and take the eight latest. These eight are what the page should show.

If the user gives a PDF that is somewhere else (Dropbox, Downloads), copy it into the folder under that naming first.

Compare the eight with `_data/accounting.yml`:

- A report without a data entry is new: do steps 2 and 3 for it.
- A data entry for a quarter outside the eight is removed in step 3.
- If nothing differs, say so and stop.

## 2. Take four figures from each new report

Read the PDF with the Read tool; if reading with `pages` fails because poppler is missing, read it without `pages`. Check the header: the company is Adaptiv Sthlm AB, the document is a "Resultatrapport", and the line `Period YYYY-MM-DD - YYYY-MM-DD` is one quarter and matches the file name.

The report has three number columns: Period, Ackumulerat and Period fg år. Use only the first one.

| Row in the report | Field | Sign |
|---|---|---|
| Summa nettoomsättning | `revenue` | as printed |
| Summa övriga externa kostnader | `external_costs` | positive (the report prints it negative) |
| Summa personalkostnader | `personnel_costs` | positive (the report prints it negative) |
| RÖRELSERESULTAT | `operating_result` | as printed; negative in a loss quarter |

Use RÖRELSERESULTAT, not the result after tax: the April-June report contains year-end postings (tax, årets resultat) that would distort the comparison between quarters.

Then reconcile to the öre, with exact arithmetic:

```bash
python3 -c "from decimal import Decimal as D; r,e,p,o=map(D,'2091092.70 292488.14 1301917.37 496687.19'.split()); print(r-e-p==o, r-e-p-o)"
```

`revenue - external_costs - personnel_costs` must equal `operating_result`. If it does not, stop and tell the user what differs. The usual causes are a misread digit, other operating income (SUMMA RÖRELSENS INTÄKTER differs from Summa nettoomsättning) or a cost group the charts do not know about, such as depreciation. The charts split revenue into exactly these parts, so a new group needs a decision from the user, not a quiet adjustment.

## 3. Update the data

`_data/accounting.yml` holds one entry per quarter, oldest first (the template reverses it). Add the new entries in date order and remove the entries for quarters outside the eight:

```yaml
- from: 2026-07-01
  to: 2026-09-30
  pdf: /assets/pdf/accounting/Resultatrapport_20260701-20260930_Adaptiv_Sthlm_AB.pdf
  revenue: 1234567.89
  external_costs: 234567.89
  personnel_costs: 900000.00
  operating_result: 100000.00
```

Decimal point, two decimals, no thousands separators. `pdf` is the file's actual name, underscores included. Check `from` and `to` against the PDF: the labels in the charts and in the list under "Kvartalsrapporter" are written from them.

Leave the PDFs themselves in the folder, also the ones older than the eight. They are published and may be linked from elsewhere; deleting them is the user's call.

## 4. Leave the figures of earlier quarters as they are

The "Period fg år" column often differs from what the report for that quarter said a year earlier, because accruals are moved afterwards. Do not update the older entry: each quarter shows the figures from its own report, so the chart matches the PDF it links to. Mention the difference to the user if it is large.

## 5. Verify

If `make start` is running, the site regenerates by itself; otherwise run `bundle exec jekyll build`. Then check the built page (`http://localhost:4000/accounting/` or `_site/accounting/index.html`):

- Both charts and the list show the same eight quarters, newest on top, and the new quarter's values match the PDF (kronor per 100 kr in the first chart, mkr in the second).
- Every link in the charts and in the list points to a file that exists in `_site/assets/pdf/accounting/`.
- A loss quarter shows "förlust N kr" in the first chart and a bar to the left of the zero line in the second.

The two legends have a `--one-row` width in `_includes/accounting.html`; it only needs changing if the legend texts change.

## 6. Report

Tell the user which quarters were added and which were removed, the four figures of each new one and that they reconcile, and anything that looked off (restated earlier quarters, unusual rows). Do not commit or push unless asked: a push to `main` publishes the site.
