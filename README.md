# 🏫 Menaka's ICL — Student Management System

> **A full-stack Java web application for managing students, staff, courses and fees — built with Servlets, JSP, JDBC and MySQL.**
>
> *"Shaping minds, inspiring futures."*

**Stack:** Java 17 · Jakarta Servlets · JSP · MySQL 9.6 · Tomcat 10.1 · Maven
---

## 🚀 Features

### Admin Portal
- ✅ Secure login with username/email + password
- ✅ **Manage Students** — Add, Update, Delete, View by Roll No, View All with live search
- ✅ **Manage Courses** — Add, Update, Delete, View All card grid
- ✅ **Manage Fees** — Add, Update, View All with PAID/PENDING summary
- ✅ **Staff Management** — Add, Update, View All, Mark Attendance
- ✅ Session-secured dashboard with logout + cache-clearing

### Student Portal
- ✅ Login with Roll Number + Contact Number as password
- ✅ View Personal Details — avatar card + detail grid
- ✅ View Fee Records — PAID/PENDING badges
- ✅ View Enrolled Courses
- ✅ Secure session with logout

### Staff Portal
- ✅ Login with Staff ID — password is Staff ID itself
- ✅ View My Profile
- ✅ View My Attendance — big number display
- ✅ View My Salary — monthly + annual breakdown
- 🔜 Assigned Students, Leave Request, Timetable, Results Entry, Announcements, Messaging

---

## 🏗️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Java 17 |
| Backend | Jakarta Servlets + JSP |
| Database | MySQL 9.6 |
| DB Driver | MySQL Connector/J 9.6.0 |
| Server | Apache Tomcat 10.1 |
| Build Tool | Maven 3.13 |
| Architecture | MVC (Model-View-Controller) |
| IDE | Eclipse |

---

## 🗂️ Project Structure
```
admin_portal/
├── src/main/
│   ├── java/
│   │   ├── Admin/AdminController.java
│   │   ├── Staff/StaffController.java
│   │   ├── Student/StudentController.java
│   │   └── com/
│   │       ├── adminModel/   — AdminDAO, Course, Fees, Staff
│   │       ├── studentModel/ — Student, StudentDAO
│   │       ├── staffModel/   — StaffDAO
│   │       ├── verify/       — VerifyLogin, VerifyStudent, StaffVerifier
│   │       └── logout/       — AdminLogoutServlet, LogoutServlet
│   └── webapp/
│       ├── index.jsp                 — Login page (3-role toggle)
│       ├── AdminFeatures.jsp         — Admin dashboard
│       ├── StudentFeatures.jsp       — Student dashboard
│       ├── StaffFeatures.jsp         — Staff dashboard
│       ├── CommonLoginError.jsp      — Error + countdown redirect
│       ├── student — Details, Fees, Courses
│       ├── staff   — Profile, Attendance, Salary
│       └── admin   — Add/Update/Delete/View for Student, Course, Fee, Staff
└── pom.xml
```

---

## 🗄️ Database Schema

**Database:** `studentrecords`
```
Admins         — admin_id, username, password, email, phone, role
Staff          — staff_id, staff_name, role, department, age, salary, attendance
Student        — roll_number (PK), student_name, age, grade, section, fees, address, parent_name, contact_number
Course         — course_id (PK), course_name, course_description, course_fee
Student_Course — roll_number + course_id (many-to-many, CASCADE)
Fees           — fee_id, roll_number (FK), amount, status (PAID/PENDING), due_date
```

**Database Stats:**
- 🎓 510 Students — Tamil Nadu, All India + Europe
- 👨‍🏫 55 Staff members
- 📚 20 Courses
- 💰 510 Fee records

---

## ⚙️ Setup & Installation

### Prerequisites
- Java 17+
- Apache Tomcat 10.1
- MySQL 8+
- Eclipse IDE or any Maven IDE
- Maven 3+

### Step 1 — Clone
```bash
git clone https://github.com/msmoorthi150607s-star/menaka-icl.git
cd menaka-icl
```

### Step 2 — Database setup
```bash
mysql -u root -p < database/studentrecords.sql
```

### Step 3 — Configure DB credentials
```java
private static final String URL      = "jdbc:mysql://localhost:3306/studentrecords";
private static final String USER     = "root";
private static final String PASSWORD = "your_password";
```

### Step 4 — Build
```bash
mvn clean package
```

### Step 5 — Deploy
```
Eclipse → Right click project → Run As → Run on Server
```

### Step 6 — Open
```
http://localhost:8080/admin_portal
```

---

## 🔐 Demo Login Credentials

| Role | Field | Value |
|------|-------|-------|
| Admin | Username | `Sundar` |
| Admin | Password | `kadalamuttai@143` |
| Student | Roll Number | `STU001` |
| Student | Password | `9876500001` |
| Staff | Staff ID | `1` |
| Staff | Password | `1` |

---

## 🐛 Errors Faced & Solutions

> Real bugs I hit — so you don't have to suffer! 😄

| # | Error | Solution |
|---|-------|----------|
| 1 | Unknown version of Tomcat | Set correct Tomcat directory in Eclipse server config |
| 2 | JSTL jar missing | Add `jakarta.servlet.jsp.jstl` jar to `WEB-INF/lib` |
| 3 | `ClassNotFoundException: com.mysql.cj.jdbc.Driver` | Deployment Assembly → Add Maven Dependencies |
| 4 | Tomcat port 8080 in use | Change port to `8081` — simplest fix! 😂 |
| 5 | Session null on protected JSP | Use `session="false"` + `request.getSession(false)` manually |
| 6 | Admin redirected after login | Session key mismatch — `"username"` vs `"uname"` — must match exactly |

---

## 🏛️ MVC Architecture
```
Browser
   │
   ▼
index.jsp  ──────────────────────────── View (Login)
   │
   ▼
VerifyLogin / VerifyStudent / StaffVerifier ── Controller (Auth)
   │
   ▼
AdminController / StudentController / StaffController ── Controller (Routing)
   │
   ▼
AdminDAO / StudentDAO / StaffDAO ── Model (DB Operations)
   │
   ▼
MySQL Database
   │
   ▼
JSP Pages ───────────────────────────── View (Display)
```

---

## 🗺️ My Developer Journey

| Project | Concepts Learned |
|---------|-----------------|
| 🚌 Bus Reservation System | OOP, CRUD with Collections |
| 🏦 Bank Management System | Transactions, validations, business rules |
| 🎓 Student Management — JDBC Console | Persistence, schema design, transaction safety |
| 🌐 **Student Management — Web ← I am here 😊** | Servlets, JSP, MVC, Sessions, MySQL |
| 🍃 Spring Boot | Coming next... |

### Roadmap
```
Spring Core → Spring MVC → Spring Boot → Spring Data JPA
      → Spring Security → REST APIs → Microservices → AI Agent Developer 🤖
```

---

## 🔮 Future Features

- [ ] Spring Boot migration
- [ ] OTP-based two-factor login
- [ ] Student attendance tracking
- [ ] Staff leave request system
- [ ] Timetable management
- [ ] Results and marks entry by staff
- [ ] Announcements board
- [ ] Internal messaging system
- [ ] Payment gateway integration
- [ ] PDF report generation

---

## 👨‍💻 Developer

**Sundar M** — *HexMist*

🎯 Aspiring Java Backend Developer → Freelancer → AI Agent Developer

GitHub: https://github.com/msmoorthi150607s-star

*Built with ☕ Java, 💡 curiosity, and a lot of 🐛 debugging*

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

*Menaka's International Center for Learning — A legacy of academic excellence and holistic development.*
