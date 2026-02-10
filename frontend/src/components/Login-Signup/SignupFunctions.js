import axios from 'axios';

export function registerUser(newUserDetails) {
  return axios.post(
    '/register',
    newUserDetails,
    {
      headers: {
        'Content-Type': 'application/json'
      }
    }
  );
}

