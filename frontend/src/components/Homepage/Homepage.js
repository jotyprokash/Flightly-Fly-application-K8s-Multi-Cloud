import React from 'react'
import './homepage.css'

export default function Homepage({ history }) {

    const enterSite = (e) => {
        e.preventDefault()
        history.push('/login')
    }

    return (
        <div className="container maint-cnt">

            {/* Brand Header */}
            <div className="header-nav">
                <span className="mytext1">FLIGHTLY</span>
            </div>

            {/* Slogan */}
            <div className="slogan">
                <h1>
                    <span className="word4">Fly Beyond Borders</span>
                    <div className="message">
                        <div className="word1">crafted for comfort</div>
                        <div className="word2">powered by trust</div>
                    </div>
                </h1>
            </div>

            {/* CTA Button */}
            <a href="/#" onClick={enterSite} className="mainBtn">
                <svg width="277" height="62">
                    <defs>
                        <linearGradient id="grad1">
                            <stop offset="0%" stopColor="#7dd3fc" />
                            <stop offset="100%" stopColor="#38bdf8" />
                        </linearGradient>
                    </defs>
                    <rect x="5" y="5" rx="25" fill="none" stroke="url(#grad1)" width="266" height="50"></rect>
                </svg>
                <span>Get Started</span>
            </a>

        </div>
    )
}
