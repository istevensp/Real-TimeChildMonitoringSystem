# Questionnaire items and response scales

The surveys were administered **in Spanish** at two child development centers in
Guayaquil, Ecuador. The header row of each `.xlsx` in this folder carries the
English translation; this file keeps the Spanish original beside it so the
translation can be checked, and gives the response scale of every item.

**The answers themselves were not translated.** They are stored exactly as the
forms recorded them, because they are the raw data. `analyze_surveys.py` maps
the Spanish answer strings to the 1-5 scale; [`../results.md`](../results.md)
reports how many people chose each option.

**CDI** stands for *Centro de Desarrollo Infantil*, translated throughout as
*child development center*, the term used in this repository.

Three items are shared between questionnaires and were translated once:

- *Do you consider the application's current functions sufficient to effectively
  indicate when a child leaves the child development center?* — parents 4,
  tutors 6, coordinators 6.
- *Would you recommend using this mobile application to other child development
  centers?* — parents 5, tutors 7, coordinators 7.

---

## Response scales

Five scales, all five-point Likert. **Which scale an item used is determined by
the answers it received**, not by the wording of the question: the location
items ask how the function is *perceived* but were answered on the ease-of-use
scale, so they are reported as perceived ease of use.

### Usefulness

Parents 1, 2, 7, 8 · tutors 1, 2, 3 · coordinators 1, 3

| Value | English | As recorded |
|---|---|---|
| 1 | Not at all useful | Nada útil |
| 2 | Slightly useful | Poco útil |
| 3 | Neutral | Neutral |
| 4 | Useful | Útil |
| 5 | Very useful | Muy útil |

### Intention

Parents 4, 5 · tutors 6, 7 · coordinators 2, 6, 7

| Value | English | As recorded |
|---|---|---|
| 1 | Definitely not | Definitivamente no |
| 2 | Probably not | Probablemente no |
| 3 | Maybe | Tal vez |
| 4 | Probably yes | Probablemente sí |
| 5 | Definitely yes | Definitivamente sí |

### Satisfaction

Parents 6

| Value | English | As recorded |
|---|---|---|
| 1 | Very dissatisfied | Muy insatisfecho |
| 2 | Dissatisfied | Insatisfecho |
| 3 | Neutral | Neutral |
| 4 | Satisfied | Satisfecho |
| 5 | Very satisfied | Muy satisfecho |

The midpoint was documented as *Ni satisfecho ni insatisfecho*, but the form
stored it as **Neutral**, which is what the file contains.

### Ease of use

Parents 3 · tutors 4 · coordinators 4

| Value | English | As recorded |
|---|---|---|
| 1 | Very difficult | Muy difícil *(inferred)* |
| 2 | Difficult | Difícil *(inferred)* |
| 3 | Neutral | Neutral |
| 4 | Easy | Fácil |
| 5 | Very easy | Muy fácil |

The two lowest points are marked *inferred*: nobody chose them and the option
list of this question was not kept, so their exact wording is a
reconstruction. An option nobody chose contributes no rating, so nothing in
the analysis depends on it.

### Perceived quality

Tutors 5 · coordinators 5

| Value | English | As recorded |
|---|---|---|
| 1 | Bad | Mala |
| 2 | Fair | Regular |
| 3 | Good | Buena |
| 4 | Very good | Muy buena |
| 5 | Excellent | Excelente |

**No option below 3 was chosen on any scale**, by any of the 48 participants.

---

## parents_responses.xlsx (n = 33)

| # | Question | Scale | Original (Spanish) |
|---|---|---|---|
| 1 | After exploring the application, how do you rate the usefulness of the messaging function for facilitating communication? | usefulness | Después de explorar la aplicación, ¿cómo valora la utilidad de la función de mensajería para facilitar la comunicación? |
| 2 | What is your opinion of the usefulness of the children list, which lets tutors view the information of the children in their care? | usefulness | ¿Qué opina acerca de la utilidad de la función de listado de niños, que permite visualizar la información de los niños a cargo para los turores? |
| 3 | How do you find the location function that shows the real-time location of the children you represent while they are at the child development center? | ease of use | ¿Cómo percibe la función de localización que muestra la ubicación en tiempo real de los niños que representa cuando estos se encuentran en el CDI? |
| 4 | Do you consider the application's current functions sufficient to effectively indicate when a child leaves the child development center? | intention | ¿Considera que las funciones actuales de la aplicación son suficientes para indicar de manera efectiva cuando un niño sale del CDI? |
| 5 | Would you recommend using this mobile application to other child development centers? | intention | ¿Recomendaría el uso de esta aplicación móvil a otros Centros de Desarrollo Infantil? |
| 6 | Overall, how satisfied are you with your experience of using the mobile application? | satisfaction | En general, ¿qué tan satisfecho está con la experiencia de uso de la aplicación móvil? |
| 7 | Do you consider the activity log of your children useful? | usefulness | ¿Considera útil la funcionalidad de ver el registro de actividades de los hijos? |
| 8 | What is your opinion of the usefulness of the children list, which lets you view the information of the children you represent? | usefulness | ¿Qué opina acerca de la utilidad de la función de listado de niños, que le permite visualizar la información de los niños que representa? |

**Item 2 contains a typo in the original**, *"turores"* for *"tutores"*
(tutors). The typo was not carried into the translation.

**Items 2 and 8 ask about the same screen** from two points of view: as used by
tutors, and as used by the respondent. Parents were asked both.

---

## tutors_responses.xlsx (n = 11)

| # | Question | Scale | Original (Spanish) |
|---|---|---|---|
| 1 | After exploring the application, how do you rate the usefulness of the messaging function for communicating with parents and the coordinator of the child development center? | usefulness | Después de explorar la aplicación, ¿cómo valora la utilidad de la función de mensajería para facilitar la comunicación con los padres de familia y la coordinadora del CDI? |
| 2 | How do you rate the application's ability to upload and manage the children's daily activities, together with their description and photographic evidence? | usefulness | ¿Cómo evalúa la capacidad de la aplicación para cargar y gestionar las actividades diarias de los niños, junto con su descripción y evidencia fotográfica? |
| 3 | What is your opinion of the usefulness of the children list, which lets you view the information of the children in your care, for your work as a childcare tutor? | usefulness | ¿Qué opina acerca de la utilidad de la función de listado de niños, que le permite visualizar la información de los niños a su cargo, para su labor como tutora infantil? |
| 4 | How do you find the location function that shows the real-time location of the children in your care at the child development center? | ease of use | ¿Cómo percibe la función de localización que muestra la ubicación en tiempo real de los niños a su cargo en el CDI? |
| 5 | Overall, how would you rate the perceived usefulness of the application for your work as a childcare tutor after exploring its functions? | quality | En general, ¿cómo calificaría la utilidad percibida de la aplicación para su trabajo como tutora infantil después de explorar sus funciones? |
| 6 | Do you consider the application's current functions sufficient to effectively indicate when a child leaves the child development center? | intention | ¿Considera que las funciones actuales de la aplicación son suficientes para indicar de manera efectiva cuando un niño sale del CDI? |
| 7 | Would you recommend using this mobile application to other child development centers? | intention | ¿Recomendaría el uso de esta aplicación móvil a otros Centros de Desarrollo Infantil? |

The Spanish original is written in the feminine throughout (*tutora*,
*coordinadora*), which is how the roles are named at these centers.

---

## coordinators_responses.xlsx (n = 4)

| # | Question | Scale | Original (Spanish) |
|---|---|---|---|
| 1 | After exploring the application, do you consider the messaging function a useful tool for communicating with parents and the childcare tutors of the center? | usefulness | Después de explorar la aplicación, ¿considera que la función de mensajería es una herramienta útil para facilitar la comunicación con los padres de familia y las tutoras infantiles del CDI? |
| 2 | Did the application provide you with the information needed to supervise the activities? | intention | ¿La aplicación le brindó la información necesaria para supervisar las actividades? |
| 3 | What is your opinion of the usefulness of the children list, which lets you view the information of all the children at the center? | usefulness | ¿Qué opina acerca de la utilidad de la función de listado de niños, que le permite visualizar la información de los niños que conforman el CDI? |
| 4 | How do you find the location function that shows the real-time location of the children at the child development center? | ease of use | ¿Cómo percibe la función de localización que muestra la ubicación en tiempo real de los niños que se encuentran en el CDI? |
| 5 | Overall, how would you rate the perceived usefulness of the application for your work as a coordinator (supervisor) after exploring its functions? | quality | En general, ¿cómo calificaría la utilidad percibida de la aplicación para su trabajo como coordinadora (supervisora) después de explorar sus funciones? |
| 6 | Do you consider the application's current functions sufficient to effectively indicate when a child leaves the child development center? | intention | ¿Considera que las funciones actuales de la aplicación son suficientes para indicar de manera efectiva cuando un niño sale del CDI? |
| 7 | Would you recommend using this mobile application to other child development centers? | intention | ¿Recomendaría el uso de esta aplicación móvil a otros Centros de Desarrollo Infantil? |

**Item 2 is the lowest-rated item of all three questionnaires** (4.25, n = 4).
It asks whether the application gave coordinators the information they need to
*supervise*, which is the closest item to the purpose the system is built for.
