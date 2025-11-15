<div dir="rtl" style="text-align: right;">

# Docs-as-System VS Code Extension

ההרחבה Docs-as-System ל VS Code מאפשרת ליצור ולהפעיל פרויקטים לפי המתודולוגיה Docs-as-System, ישירות מתוך העורך.

ההרחבה יוצרת שלד פרויקט מלא, כולל:
• תיקיית `docs` עם תבניות למסמכים  
• תיקיית `src` לקוד המקור  
• סקריפטי אוטומציה ל Git  
• קבצי תצורה בסיסיים  

המטרה היא לחבר בין:

• סביבת הפיתוח  
• התיעוד  
• וסוכן ה AI  

באותו מקום.

---

## דרישות מוקדמות

- **Node.js** מותקן על המחשב (לצורך תמיכה בתבניות והורדת מסמכים מ-GitHub)
- **VS Code** גרסה 1.106.0 ומעלה

# התקנה

### התקנה ממרכז ההרחבות של VS Code (עתידי)

לאחר פרסום ההרחבה, תוכל להתקין אותה ישירות מ-VS Code Marketplace:

1. פתח את VS Code
2. עבור לתצוגת הרחבות (Ctrl+Shift+X)
3. חפש "Docs-as-System"
4. לחץ על Install

### התקנה מתוך VSIX (שלב פיתוח)

אם אתה עובד מקומית עם הריפו:

1. שכפל את הריפו:
```bash
git clone https://github.com/tomkedem/Docs-as-System-VSCode-Extension.git
cd Docs-as-System-VSCode-Extension
```

2. התקן תלויות ובנה את ההרחבה:
```bash
npm install
npm run compile
```

3. צור קובץ VSIX:
```bash
npx @vscode/vsce package
```
פעולה זו יוצרת קובץ:
```
docs-as-system-vscode-extension-0.0.1.vsix
```

4. התקן ב-VS Code:
   - פתח VS Code
   - עבור לתצוגת הרחבות (Ctrl+Shift+X)
   - לחץ על תפריט שלוש הנקודות למעלה
   - בחר **Install from VSIX**
   - בחר את קובץ ה-VSIX שנוצר

לאחר ההתקנה תראה את ההרחבה ברשימת ההרחבות.
---
## שימוש

אחרי התקנת ההרחבה:

1. פתח את VS Code בספרייה שבה תרצה ליצור פרויקט חדש, או בספרייה ריקה

2. פתח את Command Palette  
   (קיצור: **Ctrl+Shift+P** או **Cmd+Shift+P** ב-macOS)

3. חפש את הפקודה:
   ```
   Docs-as-System: Create New Docs-as-System Project
   ```

4. בחר את הפקודה

5. הזן שם לתיקיית הפרויקט החדשה

ההרחבה תיצור עבורך פרויקט מלא לפי Docs-as-System.

בסיום תראה תיקייה חדשה עם:

- תיקיית **`docs/`** מלאה בתבניות מסמכים (agent, architecture, automation, logs, planning, project)
- תיקיית **`src/`** לקוד המקור  
- תיקיית **`automation/git/`** עם סקריפטי Git (יצירת branch, commit, push, pull request)
- קבצי תצורה: `.gitignore`, `.editorconfig`, `.gitattributes`  
- `CHANGELOG.md` בסיסי לפרויקט החדש

התבניות מתקבלות אוטומטית מ-GitHub repository:  
https://github.com/tomkedem/Docs-as-System-StarterKit-He

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

הקובץ `src/extension.ts` הוא נקודת הכניסה של ההרחבה.  
הוא רושם את הפקודה `docsAsSystem.initProject` ומפעיל את סקריפט היצירה `src/init.cjs` הפנימי.

## קשר ל-Docs-as-System Templates

ההרחבה מורידה תבניות ישירות מ-GitHub repository המרכזי:  
**https://github.com/tomkedem/Docs-as-System-StarterKit-He**

• התבניות מכילות מסמכי תיכנון, ארכיטקטורה, אוטומציה ולוגים  
• ההרחבה יוצרת מבנה פרויקט מלא עם `docs/`, `src/`, `automation/git/`  
• כל פרויקט חדש מקבל את המסמכים והתצורה המעודכנים ביותר
## רישיון
MIT License  
ההרחבה חופשית לשימוש, שינוי והטמעה בכל פרויקט.

## מחבר ההרחבה

פותח על ידי תומר קדם כחלק ממערך הכלים הרשמיים של Docs-as-System.

---

## ריפו GitHub

https://github.com/tomkedem/Docs-as-System-VSCode-Extension

</div>