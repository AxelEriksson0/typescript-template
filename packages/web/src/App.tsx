import { circle } from "../styled-system/patterns/circle"

export const App = () => {
  console.log(circle)
  return <div style={{ margin: "5%" }}>
    <p>Hello world</p>
    <div style={circle({ overflow: "hidden", size: "5rem" })}>
      <img
        alt="avatar"
        src="https://placehold.co/400" />
    </div>
  </div>
}
