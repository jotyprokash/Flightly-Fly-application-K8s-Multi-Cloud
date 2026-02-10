import axios from 'axios';

const API_BASE = 'http://localhost:8080';

/* ======================
   LOGIN
====================== */
export function logUserIn(userCredentials) {
  return axios.post(
    `${API_BASE}/login`,
    userCredentials,
    {
      headers: {
        'Content-Type': 'application/json',
      },
    }
  );
}

/* ======================
   GET CURRENT USER
   (Protected route)
====================== */
export function getCurrentUser() {
  const token = localStorage.getItem('token');

  return axios.get(
    `${API_BASE}/user`,
    {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    }
  );
}