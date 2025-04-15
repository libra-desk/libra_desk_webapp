# LibraDesk Frontend

This is the **frontend Rails app** for **LibraDesk**, a microservice-based library management system.  
It communicates with multiple backend microservices:

- **Book MS**: Manages book data and PDF uploads.
- **Student MS**: Handles student registrations and profiles.
- **Borrowing MS**: Manages borrowing and returning of books.
- **Auth MS**: Used for handling signing up and logging in and to issue tokens in return.
- **Notification MS**: Sends out Email by listening to Kafka events

---

## Features

- View all books
- Add/edit/delete books with PDF upload support
- View individual book details
- Add students via a form
- Borrowing integration with Borrowing MS
- Interactive frontend using Rails views
- Sends out emails when someone borrows or returns a book

---

## 🧱 Tech Stack

- Ruby on Rails (Frontend)
- RestClient + Net::HTTP for communication with microservices
- Kafka for communicating async with other microservices
- Bootstrap for styling
- JSON for data serialization
- Active Storage used in Book MS for handling file uploads

---

## 🔗 Microservices Used

| Service         | URL                      | Port |
|------------------|--------------------------|------|
| Book MS     | `http://localhost:3001`  | 3001 |
| Student MS  | `http://localhost:3002`  | 3002 |
| Borrowing MS| `http://localhost:3003`  | 3003 |
| Auth MS| `http://localhost:3004`  | 3004 |
| Notification MS|

---

## 🛠 Setup Instructions

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/libra_desk_webapp.git
   cd libra_desk_webapp

