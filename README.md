<div dir="rtl" style="text-align: right;">

# Docs-as-System VS Code Extension

ההרחבה Docs-as-System ל VS Code מאפשרת ליצור ולהפעיל פרויקטים לפי המתודולוגיה Docs-as-System, בלי לצאת מהעורך.

ההרחבה מחוברת ל CLI הרשמי  
`docs-as-system-starterkit-he`  
ומריצה אותו מתוך VS Code כדי ליצור שלד פרויקט מלא, כולל תיקיית docs, תבניות ותצורה ראשונית לסוכן.

המטרה היא לחבר בין:

• סביבת הפיתוח  
• התיעוד  
• וסוכן ה AI  

באותו מקום.

---

## דרישות מוקדמות

לפני התקנת ההרחבה מומלץ לוודא:

1. שהתקנת על המכונה את Node.js ו npm  
2. שאתה יכול להריץ משורת הפקודה:

```bash
npx docs-as-system-starterkit-he --help
```
אחרי שה CLI עובד, ההרחבה תדע להשתמש בו.

# התקנה

### התקנה מתוך VSIX (שלב פיתוח)

אם אתה עובד מקומית עם הריפו:

1. בתיקייה של ההרחבה:

```bash
npm install
npm run compile
npx @vscode/vsce package
```
פעולה זו יוצרת קובץ VSIX:
```bash
docs-as-system-vscode-extension-0.0.1.vsix
```
2. פתח VS Code רגיל

3. עבור לתצוגת הרחבות

4. בתפריט שלוש הנקודות בחר  
Install from VSIX

5. בחר את קובץ ה VSIX שנוצר

לאחר ההתקנה תראה את ההרחבה ברשימת ההרחבות, עם האיקון שהוגדר.
---
## שימוש

אחרי התקנת ההרחבה:

1. פתח את VS Code בספרייה שבה תרצה ליצור פרויקט חדש, או בספרייה ריקה

2. פתח את Command Palette  
(קיצור: Ctrl+Shift+P)

3. חפש:

```
Docs-as-System: Create New Docs-as-System Project
```
בחר את הפקודה

הזן שם לתיקיית הפרויקט החדשה

ההרחבה תריץ את ה CLI ותייצר עבורך פרויקט מלא לפי Docs-as-System

בסיום תראה תיקייה חדשה עם:

- תיקיית `docs` מלאה בתבניות  
- תיקיית `src/automation/git` עם סקריפטי Git  
- קובצי תצורה כמו `.gitignore`, `.editorconfig`, `.gitattributes`  
- `README` בסיסי לפרויקט החדש

---

## מבנה פרויקט ההרחבה
</div> 
<div dir="ltr" style="text-align: left;">

```plaintext
📁 Docs-as-System-VSCode-Extension/
├── 📄 package.json
├── 📄 tsconfig.json
├── 📄 eslint.config.mjs
├── 📄 README.md
├── 📁 src/
│   └── 📄 extension.ts
├── 📁 out/
│   └── 📄 extension.js        (נוצר מקומפילציה)
├── 📁 images/
│   └── 📄 icon.png
└── 📁 .vscode/
    ├── 📄 launch.json
    ├── 📄 tasks.json
    └── 📄 extensions.json
```

</div> 
<div dir="rtl" style="text-align: right;">

הקובץ src/extension.ts הוא נקודת הכניסה של ההרחבה.
הוא רושם את הפקודה docsAsSystem.initProject ומריץ את ה CLI דרך npx.

קשר ל Docs-as-System StarterKit

ההרחבה לא מחליפה את ה CLI, אלא עוטפת אותו.

• ה CLI אחראי ליצור את שלד הפרויקט, התבניות והמסמכים
• ההרחבה מאפשרת להפעיל את ה CLI מתוך VS Code בצורה נוחה

אם תרצה לעבוד רק משורת הפקודה, תוכל להשתמש רק ב:
```
npx docs-as-system-starterkit-he init my-project
```
## רישיון
MIT License  
ההרחבה חופשית לשימוש, שינוי והטמעה בכל פרויקט.

## מחבר ההרחבה

פותח על ידי תומר קדם כחלק ממערך הכלים הרשמיים של Docs-as-System.

---

## ריפו GitHub

https://github.com/tomkedem/Docs-as-System-VSCode-Extension

</div>