import { LanguageToggle } from "../LanguageToggle/LanguageToggle.tsx"
import { m } from "../../paraglide/messages.js"

export const Navbar = () => {
  return <div class="navbar bg-base-100 shadow-sm">
    <div class="flex-1">
      <a class="btn btn-ghost text-xl">{m.navbar_title()}</a>
    </div>
    <div class="flex-none">
      <LanguageToggle />
    </div>
  </div>
}
