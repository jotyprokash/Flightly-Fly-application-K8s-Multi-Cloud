import React, { useState } from 'react'
import './Routeselector.css'
import * as apiCall from './routeApifunc'
import BusList from '../BusList/BusList'

export default function Routeselector() {
    const [dataInp, setData] = useState("")
    const [startCity, setStartCity] = useState('')
    const [destination, setDestination] = useState('')

    const handleToCity = e => {
        e.preventDefault()
        setDestination({ destination: e.target.value })
        localStorage.setItem("destination", e.target.value)
    }

    const renderBusList = (dataInp) => {
        if (Object.keys(dataInp).length > 0) {
            return (<BusList value={dataInp} />)
        }
    }

    const handleFromCity = e => {
        e.preventDefault()
        setStartCity({ startCity: e.target.value })
        localStorage.setItem("start", e.target.value)
    }

    const getRoutes = e => {
        e.preventDefault()
        apiCall.getRoutesFromApi(startCity.startCity, destination.destination)
            .then(response => response.data)
            .then(data => {
                setData(data.bus)
            })
    }

    const handleDate = e => {
        e.preventDefault()
        localStorage.setItem("date", e.target.value)
    }

    return (
        <div className="rdc">
            <div className="main-container">
                <form className="form-inline" onSubmit={e => getRoutes(e)}>

                    {/* FROM */}
                    <select
                        data-style="btn-new"
                        className="selectpicker"
                        onChange={e => handleFromCity(e)}
                    >
                        <option>FROM</option>
                        <option>Dhaka</option>
                        <option>Chattogram</option>
                        <option>Sylhet</option>
                        <option>Rajshahi</option>
                        <option>Khulna</option>
                        <option>Barishal</option>
                        <option>Cox&apos;s Bazar</option>
                        <option>Jessore</option>
                        <option>Cumilla</option>
                        <option>Rangpur</option>
                        <option>Bogura</option>
                        <option>Saidpur</option>
                        <option>Pabna</option>
                        <option>Mymensingh</option>
                        <option>Dinajpur</option>
                        <option>Noakhali</option>
                        <option>Feni</option>
                    </select>

                    {/* TO */}
                    <select
                        data-style="btn-new"
                        className="selectpicker"
                        onChange={e => handleToCity(e)}
                    >
                        <option>TO</option>
                        <option>Dhaka</option>
                        <option>Chattogram</option>
                        <option>Sylhet</option>
                        <option>Rajshahi</option>
                        <option>Khulna</option>
                        <option>Barishal</option>
                        <option>Cox&apos;s Bazar</option>
                        <option>Jessore</option>
                        <option>Cumilla</option>
                        <option>Rangpur</option>
                        <option>Bogura</option>
                        <option>Saidpur</option>
                        <option>Pabna</option>
                        <option>Mymensingh</option>
                        <option>Dinajpur</option>
                        <option>Noakhali</option>
                        <option>Feni</option>
                    </select>

                    <input type="date" onChange={e => handleDate(e)} />
                    <input type="submit" className="btn btn-primary btn-md getRoute" />
                </form>

                <div>
                    {renderBusList(dataInp)}
                </div>
            </div>
        </div>
    )
}
