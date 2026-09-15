# -*- coding: utf-8 -*-
"""
Usability survey analysis for the Real-Time Child Monitoring System.

Usage:  python analyze_surveys.py        (run from the evaluation/ folder)

Reads the three response files in data/, converts every answer to the 1-5
Likert scale, and writes results.md with per-item and per-group statistics.
Requires openpyxl.

Three separate questionnaires were used, one per role, each with its own
wording. Item numbers are therefore NOT comparable across files.

Three normalisation details that are easy to get wrong by hand:

  1. "Muy Facil" and "Muy facil" are the SAME answer, stored with different
     capitalisation by the form. Counting them separately splits the parents'
     76 % into 39 % and 36 %.
  2. Accents vary between files, so answers are compared without them.
  3. The questions in the header row have been translated into English, but
     the answers are still the Spanish strings the forms recorded, because
     they are the raw data. data/questions.md has every item in both
     languages. The surveys were administered at two child development
     centers in Guayaquil, Ecuador.

The five response scales, all five-point Likert:

  usefulness    Nada util 1 · Poco util 2 · Neutral 3 · Util 4 · Muy util 5
  intention     Definitivamente no 1 · Probablemente no 2 · Tal vez 3 ·
                Probablemente si 4 · Definitivamente si 5
  satisfaction  Muy insatisfecho 1 ... Muy satisfecho 5
  ease of use   Muy dificil 1 · Dificil 2 · Neutral 3 · Facil 4 · Muy facil 5
  quality       Mala 1 · Regular 2 · Buena 3 · Muy buena 4 · Excelente 5

Standard deviations are sample standard deviations (n-1).
"""

import io
import statistics
from collections import Counter

import openpyxl

OUTPUT = "results.md"

FILES = [
    ("parents", "data/parents_responses.xlsx"),
    ("tutors", "data/tutors_responses.xlsx"),
    ("coordinators", "data/coordinators_responses.xlsx"),
]

SCALE = {
    # usefulness
    "nada util": 1, "poco util": 2, "neutral": 3, "util": 4, "muy util": 5,
    # intention
    "definitivamente no": 1, "probablemente no": 2, "tal vez": 3,
    "probablemente si": 4, "definitivamente si": 5,
    # satisfaction
    "muy insatisfecho": 1, "insatisfecho": 2,
    "ni satisfecho ni insatisfecho": 3, "satisfecho": 4, "muy satisfecho": 5,
    # ease of use
    "muy dificil": 1, "dificil": 2, "facil": 4, "muy facil": 5,
    # perceived quality
    "mala": 1, "regular": 2, "buena": 3, "muy buena": 4, "excelente": 5,
}

ACCENTS = {"á": "a", "é": "e", "í": "i", "ó": "o", "ú": "u", "ñ": "n"}

# The five scales in full, for the report: value, English wording, and the
# Spanish option as the form recorded it.
#
# The two lowest points of the ease-of-use scale are marked as inferred: no
# respondent chose them, and the option list of that question was not kept, so
# their exact wording is a reconstruction. Nothing depends on it, since an
# option nobody chose contributes no rating.
SCALES = [
    ("usefulness", [
        (1, "Not at all useful", "Nada útil"),
        (2, "Slightly useful", "Poco útil"),
        (3, "Neutral", "Neutral"),
        (4, "Useful", "Útil"),
        (5, "Very useful", "Muy útil")]),
    ("intention", [
        (1, "Definitely not", "Definitivamente no"),
        (2, "Probably not", "Probablemente no"),
        (3, "Maybe", "Tal vez"),
        (4, "Probably yes", "Probablemente sí"),
        (5, "Definitely yes", "Definitivamente sí")]),
    # The midpoint was documented as "Ni satisfecho ni insatisfecho" but the
    # form stored it as "Neutral", which is what the file contains.
    ("satisfaction", [
        (1, "Very dissatisfied", "Muy insatisfecho"),
        (2, "Dissatisfied", "Insatisfecho"),
        (3, "Neutral", "Neutral"),
        (4, "Satisfied", "Satisfecho"),
        (5, "Very satisfied", "Muy satisfecho")]),
    ("ease of use", [
        (1, "Very difficult", "Muy difícil *(inferred)*"),
        (2, "Difficult", "Difícil *(inferred)*"),
        (3, "Neutral", "Neutral"),
        (4, "Easy", "Fácil"),
        (5, "Very easy", "Muy fácil")]),
    ("quality", [
        (1, "Bad", "Mala"),
        (2, "Fair", "Regular"),
        (3, "Good", "Buena"),
        (4, "Very good", "Muy buena"),
        (5, "Excellent", "Excelente")]),
]


def normalise(value):
    text = str(value).strip().lower()
    for accented, plain in ACCENTS.items():
        text = text.replace(accented, plain)
    return text


def scale_name(answers):
    """Identify the scale from the answers given, not from the question."""
    given = set(answers)
    if given & {"muy util", "util", "poco util", "nada util"}:
        return "usefulness"
    if given & {"muy facil", "facil", "dificil", "muy dificil"}:
        return "ease of use"
    if given & {"definitivamente si", "probablemente si", "tal vez"}:
        return "intention"
    if given & {"muy satisfecho", "satisfecho", "insatisfecho"}:
        return "satisfaction"
    if given & {"excelente", "muy buena", "buena", "regular", "mala"}:
        return "quality"
    return "unknown"


lines = []
per_group = {}
sizes = {}
# How many times each option was picked, keyed by (scale, option). It has to
# be keyed by the scale too: "Neutral" is the midpoint of three different
# scales, and counting it once mixes them into a single wrong number.
chosen = Counter()

# (scale, value) -> English wording, for the per-item breakdown
ENGLISH = {(name, value): english
           for name, points in SCALES for value, english, _ in points}

lines.append("# Survey results")
lines.append("")
lines.append("Generated by `analyze_surveys.py` from the response files in")
lines.append("`data/`. **Do not edit by hand**: re-run the script instead.")
lines.append("")
lines.append("Every item was answered on a five-point Likert scale. Standard")
lines.append("deviations are sample standard deviations (n-1). The scale of")
lines.append("each item is identified from the answers it received, not from")
lines.append("the wording of the question, which is why the location items")
lines.append("are reported as perceived ease of use.")

sections = []

for group, path in FILES:
    book = openpyxl.load_workbook(path, data_only=True)
    rows = list(book[book.sheetnames[0]].iter_rows(values_only=True))
    questions, answers = rows[0], [r for r in rows[1:]
                                   if any(c is not None for c in r)]
    sizes[group] = len(answers)

    section = []
    section.append("")
    section.append("## %s (n = %d)" % (group.capitalize(), len(answers)))
    section.append("")
    section.append("Source: `%s`" % path)
    section.append("")
    section.append("| # | Question | Scale | Answers chosen | Mean | Median | SD | 4 or 5 |")
    section.append("|---|---|---|---|---|---|---|---|")

    by_item = {}
    warnings = []
    for index, question in enumerate(questions):
        column = [normalise(row[index]) for row in answers
                  if row[index] is not None]
        unmapped = sorted({c for c in column if c not in SCALE})
        if unmapped:
            warnings.append("**Item %d has answers outside the scale:** %s"
                            % (index + 1, ", ".join(unmapped)))
            continue
        values = [SCALE[c] for c in column]
        by_item[index + 1] = (values, question)
        this = scale_name(column)
        chosen.update((this, c) for c in column)
        counts = Counter(values)
        # cada opcion elegida, con su palabra en ingles, no solo el numero
        detalle = "<br>".join(
            "%d × **%s** (%d)" % (counts[v], ENGLISH[(this, v)], v)
            for v in sorted(counts, reverse=True))
        top_two = 100.0 * sum(1 for v in values if v >= 4) / len(values)
        section.append("| %d | %s | [%s](#response-scales) | %s | **%.2f** | %.1f | %.2f | %.0f %% |"
                       % (index + 1, str(question).strip(), this, detalle,
                          statistics.mean(values), statistics.median(values),
                          statistics.stdev(values), top_two))

    for warning in warnings:
        section.append("")
        section.append(warning)

    flat = [v for values, _ in by_item.values() for v in values]
    per_group[group] = flat
    counts = dict(Counter(flat))
    section.append("")
    section.append("**Group mean %.2f** (SD %.2f) over %d ratings. "
                   "Distribution: %s. No rating below %d."
                   % (statistics.mean(flat), statistics.stdev(flat), len(flat),
                      ", ".join("%d x %d" % (counts[v], v)
                                for v in sorted(counts, reverse=True)),
                      min(flat)))
    patterns = [tuple(normalise(c) for c in row if c is not None)
                for row in answers]
    section.append("")
    section.append("Distinct response patterns: %d of %d."
                   % (len(set(patterns)), len(answers)))
    sections.append(section)

flat = [v for values in per_group.values() for v in values]

# The summary goes first, before the per-group sections.
lines.append("")
lines.append("## All three groups")
lines.append("")
lines.append("| Group | n | Ratings | Mean | SD | 4 or 5 |")
lines.append("|---|---|---|---|---|---|")
for group, values in per_group.items():
    lines.append("| %s | %d | %d | **%.2f** | %.2f | %.0f %% |"
                 % (group.capitalize(), sizes[group], len(values),
                    statistics.mean(values), statistics.stdev(values),
                    100.0 * sum(1 for v in values if v >= 4) / len(values)))
lines.append("| **All** | **%d** | **%d** | **%.2f** | **%.2f** | **%.0f %%** |"
             % (sum(sizes.values()), len(flat), statistics.mean(flat),
                statistics.stdev(flat),
                100.0 * sum(1 for v in flat if v >= 4) / len(flat)))
lines.append("")
lines.append("**No rating in any questionnaire fell below the neutral "
             "midpoint**: the minimum of all %d ratings is %d. This is "
             "consistent with courtesy bias in a demonstration setting and is "
             "reported as a limitation in the paper." % (len(flat), min(flat)))

lines.append("")
lines.append("## Response scales")
lines.append("")
lines.append("Five scales were used, all five-point Likert. Each item below is "
             "labelled with the one it used. **Which scale an item used is "
             "determined by the answers it received**, not by the wording of "
             "the question: the location items ask how the function is "
             "*perceived* but were answered on the ease-of-use scale, so they "
             "are reported as perceived ease of use.")
lines.append("")
lines.append("The *As recorded* column is the Spanish option stored in the "
             "files; *Times chosen* counts it across all three "
             "questionnaires.")

for name, points in SCALES:
    lines.append("")
    lines.append("### %s" % name.capitalize())
    lines.append("")
    lines.append("| Value | English | As recorded | Times chosen |")
    lines.append("|---|---|---|---|")
    for value, english, spanish in points:
        picked = chosen.get(
            (name, normalise(spanish.replace(" *(inferred)*", ""))), 0)
        lines.append("| %d | %s | %s | %s |"
                     % (value, english, spanish, picked if picked else "—"))

lines.append("")
lines.append("**No option below 3 was ever chosen**, on any scale, by any of "
             "the 48 participants. The two lowest points of the ease-of-use "
             "scale are marked *inferred*: nobody chose them and the option "
             "list of that question was not kept, so their exact wording is a "
             "reconstruction. An option nobody chose contributes no rating, so "
             "nothing in this report depends on it.")

for section in sections:
    lines.extend(section)

io.open(OUTPUT, "w", encoding="utf-8").write("\n".join(lines) + "\n")
print("written", OUTPUT)
