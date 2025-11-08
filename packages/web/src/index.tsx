/* @refresh reload */
import "./index.css";

import { Route, Router } from "@solidjs/router";
import { App } from "./App.tsx";
import { render } from "solid-js/web";

const root = document.getElementById("root");

if (import.meta.env.DEV && !(root instanceof HTMLElement)) {
  throw new Error(
    "Root element not found. Did you forget to add it to your index.html? Or maybe the id attribute got misspelled?",
  );
}

render(
  () => (
    <Router>
      <Route component={App} path={["/", "/en"]} />
    </Router>
  ),
  root!,
);
