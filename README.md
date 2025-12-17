# Multi-Hub Platform

A unified web platform for sharing skills, tools, and job opportunities within local communities.

![Multi-Hub Banner](webapp/images/banner.png) <!-- Optional: Add a banner image -->

## 🚀 Features

### Three Main Hubs

- **Skills Hub**: Offer and book professional services (tutoring, repairs, creative work)
- **Tools Hub**: Rent and lend equipment with secure community verification  
- **Jobs Hub**: Find employment opportunities and hire local talent

### Core Features

- ✅ User Registration & Authentication with Email Verification
- ✅ Multi-Role System (Service Provider, Tool Owner, Job Seeker, Employer, Admin)
- ✅ Advanced Search & Filtering across all categories
- ✅ Admin Moderation Panel for content approval
- ✅ User Rating & Review System
- ✅ Responsive Design for all devices

## 📁 Project Structure

MULTI-HUB/
├── src/main/
│ ├── java/ # Java Servlets (to be implemented)
│ └── webapp/ # Frontend Implementation
│ ├── css/ # Stylesheets
│ │ ├── style.css
│ │ ├── dashboard.css
│ │ └── admin.css
│ ├── js/ # JavaScript
│ │ ├── main.js
│ │ ├── auth.js
│ │ └── search.js
│ ├── fonts/ # Font assets
│ ├── images/ # Images and icons
│ ├── WEB-INF/ # Configuration
│ │ └── web.xml
│ └── *.html # Web pages (11 pages total)
├── docs/ # Documentation
├── pom.xml # Maven build configuration
├── .gitignore # Git ignore rules
├── README.md # This file
└── LICENSE.txt # MIT License

## 🛠️ Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Frontend** | HTML5, CSS3, JavaScript | User interface and interactions |
| **Backend** | Java Servlets, JSP | Server-side logic and dynamic content |
| **Database** | Supabase (PostgreSQL) | Data storage and management |
| **Server** | Apache Tomcat 9+ | Servlet container and deployment |
| **Authentication** | Session-based with BCrypt | Secure user login and sessions |
| **Version Control** | GitHub | Team collaboration and code management |
| **Build Tool** | Apache Maven | Project building and dependency management |

## 📋 Prerequisites

- **Java Development Kit (JDK)** 11 or higher
- **Apache Maven** 3.6 or higher
- **Apache Tomcat** 9 or higher
- **Git** for version control
- **Supabase Account** for database (free tier available)

## 🚀 Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/kibreab24/multi-hub.git
cd multi-hub
