# MT1-LABEXAM: Shopping Cart Management Web Application

**Full Stack Development – Node.js Lab Examination**  
**Technology:** Node.js, HTTP Module, FS Module, Express.js (ES Modules)  
**Database:** In-memory JavaScript Array  
**Candidate Name:** ABHISHEK PANDEY  
**Repository Name:** `MT1-LABEXAM`

---

## 1. Project Overview

This project is a complete **Shopping Cart Management Web Application** developed using Node.js and Express.js, structured strictly according to the MT1 Lab Examination guidelines:

1. **Part A — Node.js HTTP Server (`httpServer.js` on Port 3000):**
   - Built exclusively with the Node.js built-in `http` and `fs` modules (without Express.js).
   - Implements native HTTP routing for `/`, `/cart`, `/about`, and `/home`.
   - Serves static files (`public/index.html`) using the Node.js `fs` module with appropriate `Content-Type` headers.
   - Handles `GET` and `POST` methods, input validation, and `404 Not Found` error states.

2. **Part B — Express.js REST API (`expressApp.js` on Port 4000):**
   - Implements a RESTful API powered by the `express` framework.
   - Parses incoming JSON requests using `express.json()`.
   - Provides full CRUD functionality:
     - `GET /cart` - Retrieve all cart items.
     - `GET /cart/:id` - Retrieve an individual cart item by route parameter with dynamic total price (`price × quantity`).
     - `POST /cart` - Add a new product with input validation and `201 Created` status code.
     - `PUT /cart/:id` - Update existing product details.
     - `DELETE /cart/:id` - Remove a product from the shopping cart.
   - Handles non-existent products with `404 Not Found` and invalid requests with `400 Bad Request`.

---

## 2. Project Directory Structure

```text
MT1-LABEXAM/
│
├── package.json               # Project manifest with ES Modules configuration
├── package-lock.json          # Dependency lockfile
├── .gitignore                 # Git ignore file for node_modules
├── httpServer.js              # Part A: Pure Node.js HTTP & FS module server (Port 3000)
├── expressApp.js              # Part B: Express.js REST API with CRUD operations (Port 4000)
├── test.js                    # Automated test verification suite
├── verify.js                  # Server runner and integration test orchestrator
├── generate_screenshots.ps1   # Automated submission screenshot generator
│
├── public/
│   └── index.html             # Static frontend page served via fs module at /home
│
└── screenshots/               # Submission evidence screenshots
    ├── 1_http_server_running.png
    ├── 2_browser_home_fs_static.png
    ├── 3_browser_welcome_route.png
    ├── 4_browser_cart_json.png
    ├── 5_express_server_running.png
    ├── 6_postman_get_all_cart.png
    ├── 7_postman_get_by_id.png
    ├── 8_postman_post_add_product.png
    ├── 9_postman_put_update_product.png
    ├── 10_postman_delete_product.png
    ├── 11_postman_404_not_found.png
    └── 12_github_commit_history.png
```

---

## 3. Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/<your-username>/MT1-LABEXAM.git
   cd MT1-LABEXAM
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

---

## 4. Running the Application

### Step 1: Start the HTTP Server (Part A - Port 3000)
Open a terminal and run:
```bash
node httpServer.js
```
**Expected Console Output:**
```text
HTTP Server running at http://localhost:3000
```

Open the following URLs in your browser:
- `http://localhost:3000/` &mdash; Welcome message in HTML format.
- `http://localhost:3000/cart` &mdash; Shopping cart items in JSON format.
- `http://localhost:3000/about` &mdash; Shopping cart application information.
- `http://localhost:3000/home` &mdash; Demonstrates static file serving of `public/index.html` via the `fs` module.

---

### Step 2: Start the Express Application (Part B - Port 4000)
Open a second terminal and run:
```bash
node expressApp.js
```
**Expected Console Output:**
```text
Express Server running at http://localhost:4000
```

---

## 5. API Reference & Testing via Postman

### Base URL: `http://localhost:4000`

### 1. Retrieve All Cart Items
- **Method:** `GET`
- **URL:** `http://localhost:4000/cart`
- **Response Status:** `200 OK`
- **Response Body:**
```json
[
  {
    "id": 1,
    "productName": "Wireless Mouse",
    "price": 799,
    "quantity": 2,
    "category": "Electronics",
    "totalPrice": 1598
  },
  {
    "id": 2,
    "productName": "Mechanical Keyboard",
    "price": 2499,
    "quantity": 1,
    "category": "Electronics",
    "totalPrice": 2499
  },
  {
    "id": 3,
    "productName": "USB-C Hub",
    "price": 1299,
    "quantity": 1,
    "category": "Accessories",
    "totalPrice": 1299
  }
]
```

---

### 2. Retrieve Cart Item by ID
- **Method:** `GET`
- **URL:** `http://localhost:4000/cart/1`
- **Response Status:** `200 OK`
- **Response Body:**
```json
{
  "id": 1,
  "productName": "Wireless Mouse",
  "price": 799,
  "quantity": 2,
  "category": "Electronics",
  "totalPrice": 1598
}
```

---

### 3. Add a New Product
- **Method:** `POST`
- **URL:** `http://localhost:4000/cart`
- **Headers:** `Content-Type: application/json`
- **Request Body:**
```json
{
  "id": 4,
  "productName": "Bluetooth Headphones",
  "price": 1499,
  "quantity": 1,
  "category": "Electronics"
}
```
- **Response Status:** `201 Created`
- **Response Body:**
```json
{
  "message": "Product added successfully",
  "product": {
    "id": 4,
    "productName": "Bluetooth Headphones",
    "price": 1499,
    "quantity": 1,
    "category": "Electronics"
  }
}
```

---

### 4. Update Product Details
- **Method:** `PUT`
- **URL:** `http://localhost:4000/cart/1`
- **Headers:** `Content-Type: application/json`
- **Request Body:**
```json
{
  "productName": "Wireless Mouse",
  "price": 899,
  "quantity": 3,
  "category": "Electronics"
}
```
- **Response Status:** `200 OK`
- **Response Body:**
```json
{
  "message": "Product updated successfully",
  "product": {
    "id": 1,
    "productName": "Wireless Mouse",
    "price": 899,
    "quantity": 3,
    "category": "Electronics",
    "totalPrice": 2697
  }
}
```

---

### 5. Remove a Product from Cart
- **Method:** `DELETE`
- **URL:** `http://localhost:4000/cart/1`
- **Response Status:** `200 OK`
- **Response Body:**
```json
{
  "message": "Product removed from cart successfully",
  "product": {
    "id": 1,
    "productName": "Wireless Mouse",
    "price": 899,
    "quantity": 3,
    "category": "Electronics"
  }
}
```

---

### 6. Error Handling (Product Not Found)
- **Method:** `GET` / `PUT` / `DELETE`
- **URL:** `http://localhost:4000/cart/999`
- **Response Status:** `404 Not Found`
- **Response Body:**
```json
{
  "message": "Product not found"
}
```

---

## 6. Automated Testing

To run the complete automated test verification suite covering all 29 test assertions across Part A and Part B:
```bash
node verify.js
```
All tests execute synchronously, starting both servers and verifying status codes, response bodies, calculations, and error handling.

---

## 7. Submission Checklist Verification

- [x] **Project Name:** `MT1-LABEXAM`
- [x] **package.json:** Initialized with `"type": "module"` and `express` dependency.
- [x] **Part A (`httpServer.js`):** Built-in HTTP and FS modules without Express, listening on port 3000.
- [x] **Static File Serving:** `public/index.html` read via `fs.readFile()` and served at `/home`.
- [x] **Part B (`expressApp.js`):** Express REST API with full CRUD endpoints listening on port 4000.
- [x] **Calculations:** Total price computed as `price × quantity`.
- [x] **Status Codes:** `200 OK`, `201 Created` for POST, `404 Not Found` for missing products/routes, `400 Bad Request` for invalid input.
- [x] **Screenshots:** All required browser, terminal, Postman, and git commit screenshots generated in `screenshots/`.
