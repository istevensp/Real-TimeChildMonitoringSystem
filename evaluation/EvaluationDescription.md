# Usability Evaluation

Raw responses and analysis of the usability surveys reported in:

> **"A Real-Time IoT-Based Child Safety and Wellbeing Monitoring System for
> Smart Childcare Centers"**, accepted as a poster at IEEE ISC2 2026.

**48 participants** from two child development centers in Guayaquil, Ecuador, answered
**three separate questionnaires**, one per role. Every answer used a five-point
Likert scale.

| Group | n | Items | Ratings | Mean | SD | 4 or 5 |
|---|---|---|---|---|---|---|
| Parents | 33 | 8 | 264 | 4.56 | 0.67 | 90 % |
| Tutors | 11 | 7 | 77 | 4.58 | 0.69 | 88 % |
| Coordinators | 4 | 7 | 28 | 4.71 | 0.53 | 96 % |
| **All** | **48** | — | **369** | **4.58** | **0.67** | **90 %** |

---

## What is here

```text
evaluation/
├── EvaluationDescription.md   this file
├── analyze_surveys.py         converts answers to 1-5 and computes the statistics
├── results.md                 every item with its scale, mean, median and SD
└── data/
    ├── questions.md           every item and scale, in Spanish and English
    ├── parents_responses.xlsx
    ├── tutors_responses.xlsx
    └── coordinators_responses.xlsx
```

**The response files contain no identifying information**: no names, no e-mail
addresses, no timestamps, no free-text fields. Every cell in every file is one
of the scale options, and every column is a question. Whether the forms never
collected identifying data or it was removed before export is not recorded
here; what can be checked is that none is present.

**The questions have been translated into English; the answers have not.** The
surveys were administered in Spanish, and the recorded answers are the raw
data, so they are left exactly as the forms stored them and mapped to 1-5 by
the script. [`data/questions.md`](data/questions.md) lists every item in both
languages so the translation can be checked.

Nothing in the files records which of the two centers a respondent came from,
so no per-center comparison is possible.

---

## How to reproduce

```bash
cd evaluation
pip install openpyxl
python analyze_surveys.py
```

This rewrites [`results.md`](results.md), which lists every item with its
question, its response scale, how many people chose each option, and the mean,
median and standard deviation. The script reads only the three files in `data/`
and holds no precomputed numbers, so any figure reported below can be checked
by running it.

---

## Method

Participants explored the mobile application and its functions, and then
answered the questionnaire for their role. **They did not use the application
during a normal working day**, so the survey captures perceived usability and
usefulness rather than adoption or operational impact.

The surveys were administered in Spanish, which is why the stored answers are
Spanish strings. `analyze_surveys.py` maps them to 1-5:

| Scale | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|
| Usefulness | Not at all useful | Slightly useful | Neutral | Useful | Very useful |
| Intention | Definitely not | Probably not | Maybe | Probably yes | Definitely yes |
| Satisfaction | Very dissatisfied | Dissatisfied | Neutral | Satisfied | Very satisfied |
| Ease of use | Very difficult | Difficult | Neutral | Easy | Very easy |
| Perceived quality | Bad | Fair | Good | Very good | Excellent |

[`data/questions.md`](data/questions.md) gives the Spanish option recorded for
each point and lists which items used each scale;
[`results.md`](results.md) adds how many people chose each option.

**The two lowest points of the ease-of-use scale are a reconstruction.** Nobody
chose them and the option list of that question was not kept, so their wording
is inferred. An option nobody chose contributes no rating, so nothing here
depends on it.

Standard deviations are sample standard deviations (n-1).

**One detail worth knowing if you reuse the raw files:** the forms stored
"Muy Fácil" and "Muy fácil" as two different strings. They are the same
answer. Counting them separately splits the parents' 76 % into 39 % and 36 %.
The script normalises capitalisation and accents before counting.

---

## Results, item by item

### Parents (n = 33)

| # | Item | Scale | Mean | SD |
|---|---|---|---|---|
| 7 | Activity log of their children | usefulness | **4.76** | 0.50 |
| 3 | Real-time location inside the center | ease of use | **4.73** | 0.52 |
| 5 | Would recommend to other centers | intention | **4.73** | 0.52 |
| 8 | Children list, as a representative | usefulness | **4.70** | 0.64 |
| 1 | Messaging | usefulness | **4.55** | 0.75 |
| 6 | Overall satisfaction | satisfaction | **4.45** | 0.62 |
| 4 | Functions sufficient to signal a child leaving | intention | **4.30** | 0.85 |
| 2 | Children list, as used by tutors | usefulness | **4.27** | 0.76 |

Items 2 and 8 ask about the same screen from two points of view. The one that
is not the respondent's own role scores **0.43 lower**.

### Tutors (n = 11)

| # | Item | Scale | Mean | SD |
|---|---|---|---|---|
| 7 | Would recommend to other centers | intention | **4.82** | 0.60 |
| 4 | Real-time location of children in their care | ease of use | **4.73** | 0.47 |
| 6 | Functions sufficient to signal a child leaving | intention | **4.64** | 0.81 |
| 1 | Messaging with parents and coordination | usefulness | **4.55** | 0.82 |
| 5 | Overall usefulness for their work | quality | **4.55** | 0.69 |
| 2 | Daily activities with photographic evidence | usefulness | **4.45** | 0.69 |
| 3 | Children list of the children in their care | usefulness | **4.36** | 0.81 |

### Coordinators (n = 4)

| # | Item | Scale | Mean | SD |
|---|---|---|---|---|
| 4 | Real-time location inside the center | ease of use | **5.00** | 0.00 |
| 7 | Would recommend to other centers | intention | **5.00** | 0.00 |
| 1 | Messaging | usefulness | **4.75** | 0.50 |
| 3 | Children list of the whole center | usefulness | **4.75** | 0.50 |
| 6 | Functions sufficient to signal a child leaving | intention | **4.75** | 0.50 |
| 5 | Overall usefulness for their role | quality | **4.50** | 0.58 |
| 2 | Provided the information needed to supervise activities | intention | **4.25** | 0.96 |

**With n = 4, each coordinator is 25 % of the result.** These means should
always be read with the n beside them.

The lowest-rated item across all three questionnaires is coordinators' item 2,
whether the application gave them the information needed to *supervise*
activities. It is the only item in that group where anyone answered "Maybe".

**It is the lowest by 0.02**, over the parents' item 2 at 4.27, and it rests on
four people. What makes it worth reporting is not the ranking but what it asks:
it is the item closest to the purpose the system is built for.

---

## Limitations

**No negative rating exists in the data.** The minimum of all 369 ratings is
3: on none of the five scales, in none of the three questionnaires, did anyone
choose an option below the midpoint. This is consistent with **courtesy bias**
in a demonstration setting, and the paper reports it as such rather than
presenting the 4.6 average on its own.

Other limits of this evaluation, also stated in the paper:

- **No task-based testing.** No completion times, success rates or errors were
  recorded; this was not a task-based usability study.
- **No validated instrument.** The questionnaires were written for this study
  rather than adapted from a standard instrument such as SUS.
- **Nothing longitudinal.** The files carry no timestamps, so not even the
  order or dates of the responses can be established.
- **Nothing per center.** The files do not record which center a respondent
  belongs to.

These are the reasons the paper describes the study as a preliminary
assessment of perceived usability, and lists structured usability instruments
and task-completion measurements as future work.
