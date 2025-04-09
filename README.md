# 📚 LibraDesk Frontend

This is the **frontend Rails app** for **LibraDesk**, a microservice-based library management system.  
It communicates with multiple backend microservices:

- **Book MS**: Manages book data and PDF uploads.
- **Student MS**: Handles student registrations and profiles.
- **Borrowing MS**: Manages borrowing and returning of books.

---

## 🚀 Features

- View all books
- Add/edit/delete books with PDF upload support
- View individual book details
- Add students via a form
- Borrowing integration with Borrowing MS
- Interactive frontend using Rails views and basic JavaScript

---

## 🧱 Tech Stack

- Ruby on Rails (Frontend)
- RestClient + Net::HTTP for communication with microservices
- Bootstrap for styling
- JSON for data serialization
- Active Storage used in Book MS for handling file uploads

---

## 🔗 Microservices Used

| Service         | URL                      | Port |
|------------------|--------------------------|------|
| Book Service     | `http://localhost:3001`  | 3001 |
| Student Service  | `http://localhost:3002`  | 3002 |
| Borrowing Service| `http://localhost:3003`  | 3003 |

---

## 🛠 Setup Instructions

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/libra_desk_webapp.git
   cd libra_desk_webapp

