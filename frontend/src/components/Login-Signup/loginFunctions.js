import axios from 'axios';

const API_BASE = '/api';

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
  const token = sessionStorage.getItem('authToken');

  return axios.get(
    `${API_BASE}/user`,
    {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    }
  );
}