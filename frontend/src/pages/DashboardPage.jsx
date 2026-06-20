import Layout from "../components/Layout";

function DashboardPage() {
  return (
    <Layout>

      <h1>Dashboard</h1>

      <p>
        Welcome back.
      </p>

      <div
        style={{
          border: "1px solid #ddd",
          padding: "20px",
          borderRadius: "8px",
          marginBottom: "20px"
        }}
      >
        <h2>Quick Actions</h2>

        <button>
          Create Project
        </button>
      </div>

      <div
        style={{
          border: "1px solid #ddd",
          padding: "20px",
          borderRadius: "8px"
        }}
      >
        <h2>My Projects</h2>

        <p>
          Your projects will appear here.
        </p>
      </div>

    </Layout>
  );
}

export default DashboardPage;
