import axios from 'axios';

// LOGIN
export function logUserIn(userCredentials) {
  return axios.post(
    '/login',
    userCredentials,
    {
      headers: {
        'Content-Type': 'application/json'
      }
    }
  );
}

// LOAD ROUTES / PROFILE (JWT via Authorization header)
export function loadRoutes() {
  const authToken = sessionStorage.getItem('authToken');
  return axios.get(
    '/user/profile',
    {
      headers: {
        Authorization: `Bearer ${authToken}`
      }
    }
  );
}

// GET CURRENT USER DETAILS
export function getCurrentUserDetails(authToken) {
  return axios.get(
    '/user/profile',
    {
      headers: {
        Authorization: `Bearer ${authToken}`
      }
    }
  );
}
