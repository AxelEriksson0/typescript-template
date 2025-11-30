import { Navbar } from "./components/Navbar/Navbar.tsx"
import { m } from "./paraglide/messages.js"

export const App = () => {
  return (
    <>
      <Navbar />
      <div class="container mx-auto px-3">
        <p class="pt-6 text-3xl mb-4">{m.home_page_title()}</p>
      </div>
    </>
  )
}
