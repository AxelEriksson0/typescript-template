export const Button = () => {
  return (
    <button
      id="test"
      // oxlint-disable-next-line no-console
      onClick={() => console.log("Clicked!")}
    >
      {"Click me!"}
    </button>
  );
};
