# Multi-Hub: Unified Community Service Platform

Multi-Hub is a web-based platform designed to empower community members by connecting them through three core hubs: Skills Hub, Tools Hub, and Jobs Hub. The system allows users to monetize expertise, rent equipment, and find local employment opportunities.

## 👥 Team Members (Group 4)
1. Kibre'ab Tsegay - Backend Lead (Authentication & Session Management)
2. Teshome Hailay - Backend Developer (Listing & Search Logic)
3. Efrata Yemane - Frontend Lead (UI/UX Design & CSS)
4. Bilal Jemal - Frontend Developer (Dashboard & Validations)
5. Goitom W/gebriel - Database Lead (Supabase & Schema Design)
6. Shmuye Welay - QA & Documentation Lead (Testing & Reports)

## 🚀 Phase 4: Core Features Implemented
- User Authentication: Role-based login and registration system.
- Admin Control Panel: Advanced dashboard for approving/rejecting listings and viewing user analytics.
- Listing Management: Functionality to upload and view pending items in the Tools and Skills hubs.
- Database Integration: Real-time data persistence using Supabase (PostgreSQL).

## 🛠 Technology Stack
- Frontend: HTML5, CSS3, JavaScript, JSP
- Backend: Java Servlets
- Database: Supabase (PostgreSQL)
- Server: Apache Tomcat 9/10
- Icons/Fonts: FontAwesome 6.0

## ⚙️ Setup & Installation Instructions
To run this project locally, follow these steps:

1. Clone the Project:
   ```bash
   git clone [https://github.com/](https://github.com/)kibreab24/Multi-Hub.git
Database Configuration:

Import the provided SQL schema (found in the /database folder) into your Supabase SQL Editor.

Update the JDBC connection strings in your DAO classes with your Supabase credentials.

Server Setup:

Open the project in an IDE.

Configure Apache Tomcat as the server.

Deploy the project and access it at http://localhost:8080/Multi-Hub/.

Admin Access:

Use the registered admin email (admin123@gmail.com) to access the Admin Control Panel.

📂 Project Structure
src/main/java: Java Servlets and DAO logic.

src/main/webapp: JSP pages, CSS styles, and client-side assets.

database/: SQL scripts for table creation.
