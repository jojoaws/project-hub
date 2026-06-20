import Layout from "../components/Layout";

function ProjectsPage() {
  return (
    <Layout>

      <h1>Projects</h1>

      <p>
        Browse community projects.
      </p>

      <div
        style={{
          border: "1px solid #ddd",
          padding: "15px",
          borderRadius: "8px"
        }}
      >

      <div
        style={{
          width: "100%",
          height: "250px",
          backgroundColor: "#e5e7eb",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          borderRadius: "8px"
        }}
     >
        Project Image
     </div>

        <h2>Title</h2>

        <p>
          Description
        </p>

        <p>
          <strong>Technology Stack:</strong>
        </p>

        <p>
          React, FastAPI, PostgreSQL, AWS
        </p>

      </div>

    </Layout>
  );
}

export default ProjectsPage;
