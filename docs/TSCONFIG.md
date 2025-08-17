# About tsconfig.json

If you open a file in packages/web, I want VSCode to reference the packages/web/tsconfig.json, and the same thing to packages/simple-function-and-test. This is currently not the case.

This can be fixed by setting the base tsconfig.json to something like:

```
{
  "files": [],
  "references": [
    { "path": "./packages/web" },
    { "path": "./packages/simple-function-and-test" },
  ]
}
```

However, something weird happens with VSCOde and JSX files as it complains there is no runtime. Therefore, for now, all TypeScript configuration is moved to tsconfig.json even though only a specific package needs it.
