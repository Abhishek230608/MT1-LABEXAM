import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

// Setup __dirname for ES Modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Port Configuration
const PORT = 3000;

// In-Memory Shopping Cart Data Array
const cartItems = [
  {
    id: 1,
    productName: "Wireless Mouse",
    price: 799,
    quantity: 2,
    category: "Electronics"
  },
  {
    id: 2,
    productName: "Mechanical Keyboard",
    price: 2499,
    quantity: 1,
    category: "Electronics"
  },
  {
    id: 3,
    productName: "USB-C Hub",
    price: 1299,
    quantity: 1,
    category: "Accessories"
  }
];

// Create HTTP Server
const server = http.createServer((req, res) => {
  const parsedUrl = new URL(req.url, `http://${req.headers.host || 'localhost:' + PORT}`);
  const pathname = parsedUrl.pathname;
  const method = req.method.toUpperCase();

  // Route 1: GET / - Welcome message in HTML format
  if (method === 'GET' && pathname === '/') {
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    res.end(`
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Shopping Cart Web Application</title>
        <style>
          body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 40px; background: #f4f6f9; color: #333; }
          .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
          h1 { color: #2563eb; margin-top: 0; }
          p { font-size: 16px; line-height: 1.6; color: #555; }
          .nav-links { margin-top: 25px; display: flex; gap: 15px; }
          .btn { display: inline-block; padding: 10px 20px; background: #2563eb; color: white; text-decoration: none; border-radius: 6px; font-weight: 500; transition: background 0.2s; }
          .btn:hover { background: #1d4ed8; }
          .btn-secondary { background: #64748b; }
          .btn-secondary:hover { background: #475569; }
          .badge { display: inline-block; padding: 4px 8px; border-radius: 4px; background: #e0f2fe; color: #0369a1; font-size: 13px; font-weight: 600; }
        </style>
      </head>
      <body>
        <div class="container">
          <span class="badge">Node.js HTTP Server</span>
          <h1>Welcome to the Shopping Cart Management Application!</h1>
          <p>This web application demonstrates the Node.js built-in <strong>HTTP module</strong>, routing, handling HTTP methods, and static file serving using the <strong>FS module</strong>.</p>
          <div class="nav-links">
            <a href="/home" class="btn">Go to Home (/home)</a>
            <a href="/cart" class="btn btn-secondary">View Cart JSON (/cart)</a>
            <a href="/about" class="btn btn-secondary">About Application (/about)</a>
          </div>
        </div>
      </body>
      </html>
    `);
    return;
  }

  // Route 2: GET /cart - List of shopping cart items in JSON format
  if (method === 'GET' && pathname === '/cart') {
    res.writeHead(200, { 'Content-Type': 'application/json; charset=utf-8' });
    res.end(JSON.stringify(cartItems, null, 2));
    return;
  }

  // Route 3: GET /about - Shopping cart application information
  if (method === 'GET' && pathname === '/about') {
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    res.end(`
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>About - Shopping Cart Management Application</title>
        <style>
          body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 40px; background: #f4f6f9; color: #333; }
          .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
          h1 { color: #2563eb; margin-top: 0; }
          p { font-size: 16px; line-height: 1.6; color: #555; }
          ul { line-height: 1.8; color: #444; }
          .nav-links { margin-top: 25px; }
          .btn { display: inline-block; padding: 10px 20px; background: #2563eb; color: white; text-decoration: none; border-radius: 6px; font-weight: 500; }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>About Shopping Cart Application</h1>
          <p>The <strong>Shopping Cart Management Web Application</strong> is built using Node.js as part of the Full Stack Development - Node.js Lab Examination.</p>
          <h3>Key Architecture & Features:</h3>
          <ul>
            <li><strong>Part A (Port 3000):</strong> Pure Node.js built-in <code>http</code> and <code>fs</code> modules handling core routing, static file delivery, and method handling without external frameworks.</li>
            <li><strong>Part B (Port 4000):</strong> Robust RESTful API implemented using <code>Express.js</code> supporting complete CRUD operations (GET, POST, PUT, DELETE).</li>
            <li><strong>Data Management:</strong> In-memory JavaScript arrays representing shopping cart items with automatic total price calculation.</li>
          </ul>
          <div class="nav-links">
            <a href="/" class="btn">Back to Welcome (/)</a>
            <a href="/home" class="btn" style="background: #10b981; margin-left: 10px;">Visit Home Page (/home)</a>
          </div>
        </div>
      </body>
      </html>
    `);
    return;
  }

  // Route 4: GET /home - Serve static index.html using the FS module
  if (method === 'GET' && pathname === '/home') {
    const filePath = path.join(__dirname, 'public', 'index.html');

    fs.readFile(filePath, 'utf-8', (err, data) => {
      if (err) {
        // Handle file-reading errors appropriately
        res.writeHead(500, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(`
          <!DOCTYPE html>
          <html>
            <head><title>500 Internal Server Error</title></head>
            <body>
              <h1>500 Internal Server Error</h1>
              <p>Unable to load the requested HTML file from the public directory.</p>
            </body>
          </html>
        `);
        return;
      }

      // Serve HTML file with appropriate Content-Type header
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      res.end(data);
    });
    return;
  }

  // Route 5: POST /add-to-cart - Accept product details in JSON format and add to array
  if (method === 'POST' && pathname === '/add-to-cart') {
    let body = '';

    req.on('data', chunk => {
      body += chunk.toString();
    });

    req.on('end', () => {
      try {
        const productData = JSON.parse(body);
        const { id, productName, price, quantity, category } = productData;

        // Validation: Required fields check
        if (id === undefined || id === null || !productName || price === undefined || price === null || quantity === undefined || quantity === null) {
          res.writeHead(400, { 'Content-Type': 'application/json; charset=utf-8' });
          return res.end(JSON.stringify({
            error: "Validation failed: 'id', 'productName', 'price', and 'quantity' are required fields."
          }));
        }

        const numPrice = Number(price);
        const numQuantity = Number(quantity);
        const numId = Number(id);

        if (isNaN(numId) || isNaN(numPrice) || numPrice < 0 || isNaN(numQuantity) || numQuantity <= 0) {
          res.writeHead(400, { 'Content-Type': 'application/json; charset=utf-8' });
          return res.end(JSON.stringify({
            error: "Validation failed: 'id' must be a valid number, 'price' must be non-negative, and 'quantity' must be positive."
          }));
        }

        // Check for duplicate product ID
        const exists = cartItems.find(item => item.id === numId);
        if (exists) {
          res.writeHead(409, { 'Content-Type': 'application/json; charset=utf-8' });
          return res.end(JSON.stringify({
            error: `Product with ID ${numId} already exists in the cart.`
          }));
        }

        // Create new product object
        const newProduct = {
          id: numId,
          productName: String(productName).trim(),
          price: numPrice,
          quantity: numQuantity,
          category: category ? String(category).trim() : "Electronics"
        };

        // Add to array
        cartItems.push(newProduct);

        // Return appropriate success message with status 201
        res.writeHead(201, { 'Content-Type': 'application/json; charset=utf-8' });
        res.end(JSON.stringify({
          message: "Product added successfully",
          product: newProduct
        }, null, 2));

      } catch (err) {
        // Handle invalid JSON requests appropriately
        res.writeHead(400, { 'Content-Type': 'application/json; charset=utf-8' });
        res.end(JSON.stringify({
          error: "Invalid request: Request body must be valid JSON."
        }));
      }
    });
    return;
  }

  // Error Handling (A5): Return HTTP status code 404 for invalid routes
  res.writeHead(404, { 'Content-Type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify({
    error: "404 Not Found: The requested route does not exist on this server."
  }, null, 2));
});

// Configure server to listen on port 3000
server.listen(PORT, () => {
  console.log(`HTTP Server running at http://localhost:${PORT}`);
});
