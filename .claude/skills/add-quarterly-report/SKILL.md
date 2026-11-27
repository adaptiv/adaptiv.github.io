---
name: add-quarterly-report
description: Add a new quarterly income statement (Resultatrapport PDF from the bookkeeping system) to the accounting page of adaptiv.se - copy the PDF into the repo, enter its figures in _data/accounting.yml so the charts include the quarter, and add the link to the list. Use this whenever the user hands over or mentions a new quarterly report, kvartalsrapport, resultatrapport or resultaträkning, asks to update the accounting page or "redovisningen" with a new quarter, or asks to fill in a missing quarter, even if they only give a PDF path.
---

# Add a quarterly report

The page `/accounting/` shows two charts drawn from `_data/accounting.yml` and a list of links to the report PDFs. A new quarter needs three things: the PDF, a data entry and a list item. The charts and the PDF they link to must show the same figures, so every number comes from the PDF and is checked before it is written.

## 1. Get the PDF

The user gives a path (often in Dropbox or Downloads). If they have not, ask for it. Read the PDF with the Read tool; if reading with `pages` fails because poppler is missing, read it without `pages`.

Check the header before going on:

- Company is Adaptiv Sthlm AB and the document is a "Resultatrapport".
- The line `Period YYYY-MM-DD - YYYY-MM-DD` covers exactly one quarter.
- That period is not already in `_data/accounting.yml`. If it is, the user probably has a corrected report; ask whether to replace the entry and the PDF.

## 2. Take four figures from the "Period" column

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

## 3. Add the three things

**The PDF.** Copy it to `assets/pdf/accounting/` as `Resultatrapport_YYYYMMDD-YYYYMMDD_Adaptiv_Sthlm_AB.pdf`. Some older files have a double underscore after "Resultatrapport"; leave those alone and use a single one for new files.

**The data entry.** Append to `_data/accounting.yml`, keeping the entries in date order, oldest first (the charts show the last eight entries of the file, newest on top):

```yaml
- from: 2026-07-01
  to: 2026-09-30
  pdf: /assets/pdf/accounting/Resultatrapport_20260701-20260930_Adaptiv_Sthlm_AB.pdf
  revenue: 1234567.89
  external_costs: 234567.89
  personnel_costs: 900000.00
  operating_result: 100000.00
```

Decimal point, two decimals, no thousands separators.

**The list item.** Add an `<li>` at the end of the list under "Kvartalsrapporter" in `_includes/accounting.html`, copying the markup of the item before it. The link text is `Resultaträkning YYMMDD-YYMMDD`. Check the end date against the PDF: a wrong end date in a label has slipped through before.

## 4. Leave earlier quarters as they are

The "Period fg år" column often differs from what the report for that quarter said a year earlier, because accruals are moved afterwards. Do not update the older entry: each quarter shows the figures from its own report, so the chart matches the PDF it links to. Mention the difference to the user if it is large.

## 5. Verify

If `make start` is running, the site regenerates by itself; otherwise run `bundle exec jekyll build`. Then check the built page (`http://localhost:4000/accounting/` or `_site/accounting/index.html`):

- The new quarter is the top row in both charts, and the oldest of the previous eight is gone, with values that match the PDF (kronor per 100 kr in the first chart, mkr in the second).
- The quarter's link in the chart and the new list item both point to a file that exists in `_site/assets/pdf/accounting/`.
- A loss quarter shows "förlust N kr" in the first chart and a bar to the left of the zero line in the second.

The two legends have a `--one-row` width in `_includes/accounting.html`; it only needs changing if the legend texts change.

## 6. Report

Tell the user the four figures, that they reconcile, and anything that looked off (restated earlier quarters, unusual rows). Do not commit or push unless asked: a push to `main` publishes the site.
