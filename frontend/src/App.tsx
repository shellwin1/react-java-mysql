import React, { useEffect, useState } from "react";
import logo from "./logo.svg";
import "./App.css";

type Greeting = {
  id: number;
  name: string;
};

function App() {
  const [greeting, setGreeting] = useState<Greeting>();
  useEffect(() => {
    fetch("/api")
      .then(res => res.json())
      .then(setGreeting)
      .catch(console.error);
  }, [setGreeting]);
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        {greeting ? (
          <p>Projektowanie i implementacja środowisk hybrydowych.</p>
        ) : (
          <p>Loading...</p>
        )}
        <p>
          Konteneryzacja z on-prem do Cloud 
        </p>
      </header>
    </div>
  );
}

export default App;
