import { useState } from "react";
import Layout from "../components/Layout";
import { FaEye, FaEyeSlash } from "react-icons/fa";

function RegisterPage() {

  const [username, setUsername] = useState("");

  const [email, setEmail] = useState("");

  const [password, setPassword] = useState("");

  const [confirmPassword, setConfirmPassword] = useState("");

  const [showPassword, setShowPassword] = useState(false);

  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const handleRegister = (e) => {

    e.preventDefault();

    console.log({
      username,
      email,
      password,
      confirmPassword
    });

  };

  return (
    <Layout>

      <h1>Register</h1>

      <form onSubmit={handleRegister}>

        <div>
          <label>Username</label>
          <br />

          <input
            type="text"
            value={username}
            onChange={(e) =>
              setUsername(e.target.value)
            }
          />
        </div>

        <br />

        <div>
          <label>Email</label>
          <br />

          <input
            type="email"
            value={email}
            onChange={(e) =>
              setEmail(e.target.value)
            }
          />
        </div>

        <br />

        <div>
          <label>Password</label>
          <br />

          <input
            type={showPassword ? "text" : "password"}
            value={password}
            onChange={(e) =>
              setPassword(e.target.value)
            }
          />

          <button
            type="button"
            onClick={() =>
              setShowPassword(!showPassword)
            }
          >
            {showPassword ? <FaEyeSlash /> : <FaEye />}
          </button>

        </div>

        <br />

        <div>
          <label>Confirm Password</label>
          <br />

          <input
            type={showConfirmPassword ? "text" : "password"}
            value={confirmPassword}
            onChange={(e) =>
              setConfirmPassword(e.target.value)
            }
          />

          <button
            type="button"
            onClick={() =>
              setShowConfirmPassword(!showConfirmPassword)
            }
          >
            {showConfirmPassword ? <FaEyeSlash /> : <FaEye />}
          </button>

        </div>

        <br />

        <button type="submit">
          Register
        </button>

      </form>

    </Layout>
  );
}

export default RegisterPage;
