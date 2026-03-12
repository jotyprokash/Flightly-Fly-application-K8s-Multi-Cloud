import axios from 'axios';

export function registerUser(newUserDetails) {
  return axios.post(
    '/api/register', // ✅ BROWSER-RESOLVABLE
    newUserDetails,
    {
      headers: {
        'Content-Type': 'application/json',
      },
    }
  );
}