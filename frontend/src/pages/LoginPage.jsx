import { useState } from "react";
import Layout from "../components/Layout";
import api from "../services/api";
import { FaEye, FaEyeSlash } from "react-icons/fa";

function LoginPage() {

  const [email, setEmail] = useState("");

  const [password, setPassword] = useState("");

  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = async (e) => {

    e.preventDefault();

    try {

      const response = await api.post(
        "/auth/login",
        {
          email,
          password
        }
      );

      console.log(response.data);

    } catch (error) {

      console.error(error);

    }

  };

  return (
    <Layout>

      <h1>Login</h1>

      <form onSubmit={handleLogin}>

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
           onClick={() => setShowPassword(!showPassword)}
         >
           {showPassword ? <FaEyeSlash /> : <FaEye />}
         </button>

        </div>

        <br />

        <button type="submit">
          Login
        </button>

      </form>

    </Layout>
  );
}
export default LoginPage;
