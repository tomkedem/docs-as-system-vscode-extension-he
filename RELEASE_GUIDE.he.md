<div dir="rtl" style="text-align: right;">

# מדריך פרסום גרסה של Docs-as-System VS Code Extension

מסמך זה מסביר צעד אחר צעד איך להוציא גרסה חדשה של ההרחבה ל-VS Code Marketplace.

---

## לפני שמתחילים

כדי לפרסם הרחבה ל-VS Code Marketplace צריך:

• **Personal Access Token (PAT)** מ-Azure DevOps עם הרשאות Marketplace  
• התקנת כלי הפרסום:
```bash
npm install -g @vscode/vsce
```

• ריפו נקי משינויים לא שמורים:
```bash
git status
```
אם יש קבצים לא משויכים או שינויים, מסיימים אותם או מבצעים commit לפני המשך התהליך.

---

## איך בוחרים מספר גרסה

ההרחבה משתמשת ב-Semantic Versioning בפורמט:
```
MAJOR.MINOR.PATCH
```

בקצרה:

• **שינוי PATCH** (למשל מ-0.0.1 ל-0.0.2)  
מיועד לתיקוני באגים או שיפורים קטנים שלא משנים פונקציונליות.

• **שינוי MINOR** (למשל מ-0.0.1 ל-0.1.0)  
מיועד להוספת פיצ'רים חדשים (פקודות, הגדרות, וכו').

• **שינוי MAJOR** (למשל מ-0.9.0 ל-1.0.0)  
מיועד לשינויים משמעותיים או שבירת תאימות לאחור.

---

## שלבי הפרסום

### 1. עדכון מספר הגרסה

ערוך את `package.json` ועדכן את השדה `version`:
```json
{
  "version": "0.0.2"
}
```

### 2. עדכון CHANGELOG.md

הוסף רשומה חדשה ב-`CHANGELOG.md` המתארת את השינויים בגרסה החדשה:
```markdown
## גרסה 0.0.2
• תיקון באג ב-X
• שיפור ביצועים ב-Y
• הוספת פיצ'ר Z
```

### 3. בדיקה מקומית

לפני פרסום, בדוק שההרחבה עובדת:
```bash
npm install
npm run compile
```

הרץ את ההרחבה במצב Debug:
- לחץ F5 ב-VS Code
- בחלון הבדיקה, הפעל את הפקודה ובדוק שהכל עובד

### 4. יצירת קובץ VSIX

צור חבילת VSIX לבדיקה סופית:
```bash
vsce package
```

זה יצור קובץ כמו:
```
docs-as-system-vscode-extension-0.0.2.vsix
```

התקן אותו ידנית ב-VS Code ובדוק פעם אחרונה.

### 5. Commit ו-Tag ב-Git

```bash
git add .
git commit -m "Release v0.0.2"
git tag v0.0.2
git push origin master
git push origin v0.0.2
```

### 6. פרסום ל-VS Code Marketplace

עם Personal Access Token:
```bash
vsce publish -p YOUR_PAT_TOKEN
```

או אם כבר התחברת בעבר:
```bash
vsce publish
```

הכלי יעלה אוטומטית את ההרחבה ל-Marketplace.

---

## בדיקה לאחר הפרסום

1. חפש את ההרחבה ב-VS Code Marketplace:  
   https://marketplace.visualstudio.com/vscode

2. התקן את ההרחבה ממרכז ההרחבות ב-VS Code ובדוק שהגרסה החדשה עובדת

3. בדוק שהקישור לריפו ב-GitHub עובד

---

## פתרון בעיות

### שגיאה: "Publisher not found"
צריך ליצור publisher ב-VS Code Marketplace:
```bash
vsce create-publisher YOUR_PUBLISHER_NAME
```

### שגיאה: "Missing icon"
ודא שיש קובץ `images/icon.png` והוא מוגדר ב-`package.json`

### שגיאה: "Invalid README"
ודא ש-README.md קיים ומכיל תוכן תקין

---

## קישורים שימושיים

• **VS Code Publishing Extensions Guide**:  
  https://code.visualstudio.com/api/working-with-extensions/publishing-extension

• **vsce Documentation**:  
  https://github.com/microsoft/vscode-vsce

• **ריפו GitHub של ההרחבה**:  
  https://github.com/tomkedem/docs-as-system-vscode-extension-he

---

© 2025 תומר קדם

</div>