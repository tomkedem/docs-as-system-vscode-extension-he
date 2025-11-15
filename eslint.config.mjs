// eslint.config.mjs
import tseslint from "typescript-eslint";

export default tseslint.config(
  // סט ברירת מחדל מומלץ עבור TypeScript
  ...tseslint.configs.recommendedTypeChecked,

  {
    files: ["src/**/*.ts"],
    languageOptions: {
      parserOptions: {
        project: ["./tsconfig.json"],
        tsconfigRootDir: import.meta.dirname
      }
    },
    rules: {
      // כאן אפשר להוסיף או לשנות חוקים מותאמים
      "@typescript-eslint/no-unused-vars": ["warn", { "argsIgnorePattern": "^_" }],
      "@typescript-eslint/explicit-function-return-type": "off"
    }
  }
);
