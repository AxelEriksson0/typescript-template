import { Navbar } from "./components/Navbar/Navbar.tsx"
import { m } from "./paraglide/messages.js"

export const App = () => {
  return (
    <>
      <Navbar />
      <div class="container mx-auto">
        <p class="pt-8 text-3xl">{m.home_page_title()}</p>
      </div>
    </>
  )
}
