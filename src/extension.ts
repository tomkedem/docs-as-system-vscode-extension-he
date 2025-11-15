import * as vscode from "vscode";
import { exec, ExecException } from "child_process";

export function activate(context: vscode.ExtensionContext) {
  const disposable = vscode.commands.registerCommand(
    "docsAsSystem.initProject",
    async () => {

      const projectName = await vscode.window.showInputBox({
        placeHolder: "הכנס שם לתיקיית הפרויקט החדשה",
        prompt: "זה יהיה שם התיקייה שתיווצר",
        ignoreFocusOut: true
      });

      if (!projectName || !projectName.trim()) {
        vscode.window.showWarningMessage("לא הוזן שם פרויקט.");
        return;
      }

      const nodePath = process.execPath;
      const initScript = require.resolve('../src/init.cjs');
      const command = `"${nodePath}" "${initScript}" init "${projectName}"`;

      vscode.window.showInformationMessage(
        "יוצר פרויקט חדש לפי Docs-as-System..."
      );

      exec(command, { cwd: vscode.workspace.rootPath }, (error: ExecException | null, stdout: string, stderr: string) => {
        if (error) {
          vscode.window.showErrorMessage(`שגיאה: ${error.message}`);
          return;
        }

        if (stderr && !stderr.includes("npm WARN")) {
          vscode.window.showWarningMessage(`אזהרה: ${stderr}`);
        }

        vscode.window.showInformationMessage(
          `הפרויקט נוצר בהצלחה בתיקייה: ${projectName}`
        );
      });
    }
  );

  context.subscriptions.push(disposable);
}

export function deactivate() {}
