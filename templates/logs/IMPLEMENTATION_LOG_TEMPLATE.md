<div dir="rtl" style="text-align: right;">

> ⚙️ **Template Notice:**  
> קובץ זה הוא תבנית רשמית של Docs-as-System.  
> אין לערוך אותו ישירות בתוך הפרויקט — בעת אתחול מערכת חדשה, יש להעתיק אותו אל תיקייה בשם `docs/logs/`  
> ולשמור את הקובץ בשם `IMPLEMENTATION_LOG.md` ולהתאים אותו לארגון.

# יומן יישום ותיעוד — Implementation Log

**מסמך בפרויקט בפועל:** `docs/logs/IMPLEMENTATION_LOG.md`  
**תבנית בתיקיית התבניות:** `templates/logs/IMPLEMENTATION_LOG_TEMPLATE.md`  
**מטרה:** לתעד אוטומטית כל פעולה, שינוי או החלטה בפרויקט בזמן אמת.  
**קבצים קשורים:**  
- `docs/agent/AGENT_OPERATIONAL_POLICY.md`  
- `docs/agent/HUMAN_OPERATIONAL_POLICY.md`  
- `docs/security/SECURITY_CHECKLIST.md`  
- `docs/validation/VALIDATION_REPORT.md`

---

## עקרון פעולה

הקובץ נוצר ומתעדכן אוטומטית על־ידי הסוכן (Agent) בזמן אמת,  
בהתבסס על מידע מ־Git, מתהליכי CI/CD, ומהרצות Self-Validation.  

האדם אינו נדרש למלא רשומות ידנית, אלא רק לאשר, להוסיף הסבר, או לתקן חריגות במידת הצורך.  
כל שינוי בלוג נחשב חלק מהיסטוריית הפרויקט ונשמר ללא דריסה.

---

## מבנה הרשומה האוטומטית

| שדה | תיאור |
|------|---------|
| **Cycle ID** | מזהה מחזור עבודה (לפי BY_CYCLE) שאליו שייכת הפעולה. |
| **תאריך ושעה** | זמן הביצוע בפורמט ISO. |
| **מזהה פעולה** | נוצר ע"י הסוכן (למשל `IMP-2025-0045`). |
| **סוג פעולה** | Commit / PR / Merge / Test / Review / Deploy / Exception. |
| **מקור** | שם הענף, ה־Pipeline או קובץ המקור. |
| **תוצאה / סטטוס** | Passed / Warning / Failed / Pending / Need Review. |
| **ביצע** | Agent / Human / Hybrid. |
| **אישור אנושי** | שם המאשר או קישור ל־PR / הערת Review. |
| **הקשר מסמך** | קישור למסמך רלוונטי (Spec / Blueprint / Plan). |
| **הערות** | תיאור קצר של המטרה או תוצאת הפעולה. |

---

## דוגמה לרשומה אוטומטית

```markdown
## 2025-11-11 14:32
Cycle: CY-2025-Q4-A
ID: IMP-2025-0045  
Action: Commit  
Source: feature/logging_cleanup  
Status: Passed  
Executed by: Agent  
Human Review: Approved by Tomer Kedem (PR-#142)  
SpecRef: docs/project/PROJECT_SPEC.md §4.3  
Notes: Removed redundant logging from service layer
```
## מקורות הנתונים

| מקור | מה נאסף ממנו |
|------|----------------|
| **Git Commit** | מזהה commit, כותב, תאריך ותקציר diff. |
| **Pull Request** | הערות מאשרים, תוצאות בדיקות וביקורת קוד. |
| **CI Pipeline** | סטטוס Build / Test / Security Scan. |
| **Agent Runtime** | פעולות אוטומטיות, Self-Checks וחריגות. |

> הסוכן מאחד את הנתונים לרשומה אחת, מוסיף אותה לקובץ הלוג,  
> ואינו משנה רשומות קיימות.

---

## חריגות ופעולות מתוקנות

כאשר מתגלת חריגה, הסוכן יוצר רשומת **Exception** ומסמן אותה לבדיקה אנושית.

```markdown
## Exception
Time: 2025-11-11 15:04  
Event: security_scan_failed  
Auto-pause: Yes  
Assigned to: Human Approver  
Resolution: Updated dependency version  
Result: Passed after retry
```

## אינטגרציה עם BY_CYCLE

כל רשומה בלוג שייכת למחזור עבודה (Cycle) ספציפי ומסומנת לפי מזהה מחזור (`CycleId`).  
בסיום כל מחזור נוצר תקציר אוטומטי המבוסס על קובץ זה —  
[`IMPLEMENTATION_LOG_SUMMARY_BY_CYCLE.md`](docs/logs/IMPLEMENTATION_LOG_SUMMARY_BY_CYCLE.md),  
שמסכם את כלל הפעולות, החריגות והסטטוסים של אותו מחזור.

---

## הנחיות לניהול לוגים

- הלוג נשמר תמיד בפורמט Markdown קריא לאדם ולמכונה.  
- אין למחוק או לשכתב רשומות קיימות.  
- כל עדכון אנושי מצוין בהערה עם שם הכותב ותאריך.  
- כל מחזור נפתח בכותרת משנה עם מזהה Cycle ברור.  
- כל Commit או Pull Request נרשם ברשומה נפרדת.  
- חובה לשמור על עקביות בתאריכים, מזהי פעולות, וקישורים למסמכים.

---

## דוגמת כותרת מחזור (Cycle Header)

```markdown
# Cycle: CY-2025-Q4-A
Period: 2025-10-01 → 2025-12-31  
Summary Link: docs/logs/IMPLEMENTATION_LOG_SUMMARY_BY_CYCLE.md
```
## סיכום

`IMPLEMENTATION_LOG.md` הוא עמוד השדרה של השיטה.  
הוא מאפשר שקיפות מלאה, בקרה בזמן אמת, ויכולת לשחזר כל שינוי שבוצע —  
בין אם בידי סוכן ובין אם בידי אדם.  

זהו מקור האמת המבצעי של כל פרויקט העובד לפי **Docs-as-System**.  
כל שינוי עובר דרכו, וכל מחזור נמדד על בסיס הנתונים שנאספו בו.


>© 2025 תומר קדם. חלק ממערך התבניות הרשמי של **Docs-as-System**.
</div>