import Layout from "../components/Layout";

function ProfilePage() {
  return (
    <Layout>

      <h1>Profile</h1>

      <div
        style={{
          border: "1px solid #ddd",
          padding: "20px",
          borderRadius: "8px",
          maxWidth: "600px"
        }}
      >

        <div
          style={{
            width: "150px",
            height: "150px",
            backgroundColor: "#e5e7eb",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            borderRadius: "50%",
            marginBottom: "20px"
          }}
        >
          Profile Picture
        </div>

        <h2>Full Name</h2>

        <p>
          user@example.com
        </p>

        <h3>Bio</h3>

        <p>
          Tell the world about yourself.
        </p>

      </div>

    </Layout>
  );
}

export default ProfilePage;
