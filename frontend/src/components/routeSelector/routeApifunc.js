import axios from 'axios'

export async function getRoutesFromApi(startCity, destination) {
    const baseURL = "/api/booking/"
    let incoming = await axios.post(baseURL, { startCity, destination })
    return incoming
}