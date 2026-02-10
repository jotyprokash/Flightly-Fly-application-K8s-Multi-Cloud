import axios from 'axios';

export function registerUser(newUserDetails) {
  return axios.post(
    'http://localhost:8080/register', // ✅ BROWSER-RESOLVABLE
    newUserDetails,
    {
      headers: {
        'Content-Type': 'application/json',
      },
    }
  );
}