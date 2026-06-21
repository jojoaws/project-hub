import { useEffect, useState } from "react";
import Layout from "../components/Layout";
import api from "../services/api";
import { FaEdit } from "react-icons/fa";

function ProfilePage() {

  const [user, setUser] =
    useState(null);

  const [bio, setBio] =
    useState("");

  const [editingBio, setEditingBio] =
    useState(false);

  useEffect(() => {

    const fetchProfile = async () => {

      const token =
        localStorage.getItem("token");

      if (!token) return;

      try {

        const response =
          await api.get(
            "/users/me",
            {
              headers: {
                Authorization:
                  `Bearer ${token}`
              }
            }
          );

        setUser(
          response.data
        );

        setBio(
          response.data.bio || ""
        );

      } catch (error) {

        console.error(error);

      }

    };

    fetchProfile();

  }, []);

  const saveBio = async () => {

    const token =
      localStorage.getItem("token");

    try {

      await api.put(
        "/users/me/bio",
        {
          bio
        },
        {
          headers: {
            Authorization:
              `Bearer ${token}`
          }
        }
      );

      setEditingBio(false);

      alert(
        "Bio updated"
      );

    } catch (error) {

      console.error(error);

    }

  };

  return (
    <Layout>

      <h1>Profile</h1>

      <div className="card profile-card">

        <div className="avatar-section">

          <div className="profile-picture">
            👤
          </div>

          <button
            className="edit-icon"
          >
            <FaEdit />
          </button>

        </div>

        <h2>
          {user?.full_name}
        </h2>

        <p className="profile-email">
          {user?.email}
        </p>

        <div className="bio-section">

          <div className="bio-header">

            <h3>
              Bio
            </h3>

            <button
              className="edit-icon"
              onClick={() =>
                setEditingBio(
                  !editingBio
                )
              }
            >
              <FaEdit />
            </button>

          </div>

          {editingBio ? (

            <>
              <textarea
                value={bio}
                onChange={(e) =>
                  setBio(
                    e.target.value
                  )
                }
                rows="4"
                style={{
                  width: "100%"
                }}
              />

              <br />
              <br />

              <button
                onClick={saveBio}
              >
                Save Bio
              </button>

            </>

          ) : (

            <p className="bio-text">

              {bio ||
                "Tell the world about yourself"}

            </p>

          )}

        </div>

      </div>

    </Layout>
  );
}

export default ProfilePage;
