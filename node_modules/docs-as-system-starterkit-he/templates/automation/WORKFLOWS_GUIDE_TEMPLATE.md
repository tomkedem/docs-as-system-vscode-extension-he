<div dir="rtl" style="text-align: right;">

> ⚙️ **הערת תבנית:**  
> קובץ זה הוא תבנית רשמית של **Docs-as-System**.  
> אין לערוך אותו ישירות בתוך מאגר השיטה.  
> בעת הקמת מערכת חדשה, יש להעתיק אותו אל `docs/automation/`  
> בשם `WORKFLOWS_GUIDE.md` ולהתאים אותו לזרימות בפועל של הפרויקט.

# 🔄 תבנית מדריך זרימות עבודה — Workflows Guide Template

**מסמך בפרויקט בפועל:** `docs/automation/WORKFLOWS_GUIDE.md`  
**תבנית בתיקיית התבניות:** `templates/automation/WORKFLOWS_GUIDE_TEMPLATE.md`  
**יוצר:** אדם (בהנחיית הסוכן)  
**מאשר:** מנהל פיתוח / ארכיטקט / DevOps Lead  
**מטרה:** להגדיר את הזרימות (Workflows) האוטומטיות שמפעילות את השיטה הלכה למעשה.

---

## 🎯 מטרת המסמך

לתאר כיצד מתבצעת עבודת הפיתוח האוטומטית בפרויקט —  
מתי הסוכן פועל, אילו תהליכים מופעלים בכל מחזור (`BY_CYCLE`),  
ואיך המערכת מבצעת את Guardrails, בדיקות ולידציה, דוחות וסיכומים  
באופן מתוזמן, עקבי וניתן לשחזור.

> המסמך נועד לאנשים ולסוכנים גם יחד:  
> הוא מגדיר *מה קורה מתי* בתוך מחזור העבודה השלם.

---

## ⚙️ רכיבי זרימה עיקריים

| רכיב | תיאור | מופעל על ידי | תדירות |
|--------|----------|----------------|------------|
| **Guardrails Check** | הפעלת בקרות בזמן אמת על פעולות סוכן | סוכן | בכל פעולה |
| **Validation Pipeline** | בדיקות אוטומטיות של עקביות, לוגים ואבטחה | סוכן | בסוף כל מחזור |
| **Log Summary Generator** | יצירת תקציר מחזור (`IMPLEMENTATION_LOG_SUMMARY_BY_CYCLE.md`) | סוכן | בסוף מחזור |
| **Human Review Request** | שליחת דוח חריגות לבדיקה אנושית | סוכן | אוטומטי בעת חריגה |
| **Compliance Sync** | סנכרון בין מדיניות תאימות למסמכים מעודכנים | אדם | אחת לשבוע |
| **Documentation Update** | רענון דפי README ו־Blueprint באופן מתוזמן | סוכן | יומי / לפי הצורך |

---

## 🧩 תרשים זרימת תהליך כללי

Start Cycle
↓
Guardrails Enforcement
↓
Agent Actions → Logging
↓
Validation Pipeline
↓
Human Review (if needed)
↓
Cycle Summary Generation
↓
End Cycle


> כל שלב מתועד ונרשם ביומן הפעולות (`IMPLEMENTATION_LOG.md`)  
> עם תג פעולה תואם (`GUARDRAILS_CHECK`, `VALIDATION_RUN`, `SUMMARY_CREATED`, וכו׳).

---

## 🧮 הוראות לסוכן — ניהול זרימות

1. בכל פתיחת מחזור (`Cycle Start`) יש לוודא יצירת מזהה חדש (`CycleId`).  
2. לכל פעולה מתועדת יש להוסיף שדה `CycleId` תואם.  
3. לאחר כל סיום מחזור:
   - להריץ את **Guardrails**.  
   - להפעיל את **Validation Pipeline**.  
   - לייצר קובץ תקציר מחזור (`IMPLEMENTATION_LOG_SUMMARY_BY_CYCLE.md`).  
   - לעדכן את הסטטוס בלוג הראשי עם תג `CYCLE_COMPLETED`.  
4. במקרה של חריגה — לעצור את הרצף, לתעד חריגה ולשלוח לאישור אנושי.

---

## 🔁 סוגי זרימות אפשריים

| סוג זרימה | מטרת ההפעלה | יוזם | תיעוד נדרש |
|--------------|----------------|--------|----------------|
| **Manual Workflow** | הפעלה יזומה על ידי אדם (בדיקה או מחזור מיוחד) | אדם | חובה לרשום ביומן פעולה |
| **Scheduled Workflow** | הרצה מתוזמנת (יומית / שבועית) ע״פ תצורה | סוכן | דו״ח אוטומטי (`SCHEDULE_RUN`) |
| **Event-Driven Workflow** | הפעלה בעקבות אירוע במערכת (Commit, Merge, וכו׳) | סוכן | רישום Trigger בלוג (`EVENT_TRIGGERED`) |
| **Recovery Workflow** | שחזור אוטומטי של מצב קודם במקרה כשל | סוכן | תיעוד חובה עם תג `ROLLBACK_EXECUTED` |

---

## 🧠 ניהול תלותים בין זרימות

- כל זרימה תלויה בתוצרים של הקודמת (Guardrails → Validation → Summary).  
- אין להריץ זרימה חלקית אלא אם אושרה מפורשות ב־`AGENT_CONFIG.yaml`.  
- יש לוודא שה־Logs ננעלים לפני הרצת Validation חדשה.  
- הסוכן מבצע Self-Check לפני כל הפעלה כדי למנוע הרצה כפולה.

---

## 🔔 דוגמת תזמון (Workflow Scheduler)

```yaml
workflows:
  daily_validation:
    trigger: "0 6 * * *"        # כל יום בשעה 6:00
    tasks:
      - run_guardrails
      - run_validation_pipeline
      - generate_summary
  weekly_compliance_sync:
    trigger: "0 7 * * 0"        # כל יום ראשון בשעה 7:00
    tasks:
      - compliance_check
      - documentation_update
```
> קובץ התצורה (`automation/workflows.yaml`) נוצר אוטומטית  
> ומעודכן בהתאם למדיניות הפרויקט והעדפות האדם המאשר.

---

## 📄 קשר למסמכים נוספים

| מסמך | תפקיד בהקשר |
|--------|--------------|
| **GUARDRAILS.md** | מגדיר את גבולות הפעולה והבקרה בזמן אמת. |
| **VALIDATION_PIPELINE.md** | מגדיר את שלבי הבדיקות בסוף מחזור. |
| **IMPLEMENTATION_LOG.md** | מרכז את כל הרשומות מהזרימות האוטומטיות. |
| **COMPLIANCE_AND_GOVERNANCE.md** | מספק את המסגרת למדיניות והאישורים. |

---

## 🧭 סיכום

`WORKFLOWS_GUIDE.md` הוא **המפה התהליכית של Docs-as-System**.  
הוא מחבר בין האדם, הסוכן והתיעוד לרצף אחד מתוזמן ומבוקר.  
הודות לו ניתן לדעת בדיוק **מה קרה, מתי ולמה** בכל מחזור עבודה.

> כל Workflow הוא ביטוי מתועד של כוונה אנושית —  
> והסוכן הוא זה שמיישם אותה במדויק ובשקיפות.

---

>© 2025 תומר קדם. חלק ממערך התבניות הרשמי של **Docs-as-System**.
</div>
