export const Button = () => {
  return (
    <button
      id="test"
      onClick={() => {
        // oxlint-disable-next-line no-console
        console.log("Clicked!")
      }}
    >
      {"Click me!"}
    </button>
  )
}
