import express from 'express';

// Create an Express application
const app = express();

// Configure port
const PORT = 4000;

// Configure middleware to parse incoming JSON requests
app.use(express.json());

// Initialize an array containing at least three sample shopping cart items (B1, B3)
let cart = [
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

// 1. GET /cart - Retrieve all cart items
app.get('/cart', (req, res) => {
  // Calculate total price for each item using price * quantity
  const cartWithTotals = cart.map(item => ({
    ...item,
    totalPrice: item.price * item.quantity
  }));
  res.status(200).json(cartWithTotals);
});

// 2. GET /cart/:id - Retrieve a cart item by ID
app.get('/cart/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);

  if (isNaN(id)) {
    return res.status(400).json({
      message: "Invalid product ID: ID must be a valid integer."
    });
  }

  const item = cart.find(p => p.id === id);

  if (!item) {
    // Return HTTP status code 404 when a product is not found
    return res.status(404).json({
      message: "Product not found"
    });
  }

  // Calculate the total price of an individual cart item using price * quantity
  const totalPrice = item.price * item.quantity;

  res.status(200).json({
    ...item,
    totalPrice
  });
});

// 3. POST /cart - Add a new product to the cart
app.post('/cart', (req, res) => {
  const { id, productName, price, quantity, category } = req.body;

  // Validate required product details
  if (id === undefined || id === null || !productName || price === undefined || price === null || quantity === undefined || quantity === null) {
    return res.status(400).json({
      message: "Invalid request: 'id', 'productName', 'price', and 'quantity' are required."
    });
  }

  const numId = parseInt(id, 10);
  const numPrice = Number(price);
  const numQuantity = parseInt(quantity, 10);

  if (isNaN(numId) || isNaN(numPrice) || numPrice < 0 || isNaN(numQuantity) || numQuantity <= 0) {
    return res.status(400).json({
      message: "Invalid data types: 'id' and 'quantity' must be positive integers, and 'price' must be a non-negative number."
    });
  }

  // Check if product with this ID already exists
  const exists = cart.find(p => p.id === numId);
  if (exists) {
    return res.status(409).json({
      message: `Product with ID ${numId} already exists in the cart.`
    });
  }

  const newProduct = {
    id: numId,
    productName: String(productName).trim(),
    price: numPrice,
    quantity: numQuantity,
    category: category ? String(category).trim() : "General"
  };

  // Add the new product to the array
  cart.push(newProduct);

  // Return HTTP status code 201 when a product is successfully added (B4, sample response on page 5)
  res.status(201).json({
    message: "Product added successfully",
    product: newProduct
  });
});

// 4. PUT /cart/:id - Update product details
app.put('/cart/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);

  if (isNaN(id)) {
    return res.status(400).json({
      message: "Invalid product ID: ID must be a valid integer."
    });
  }

  const productIndex = cart.findIndex(p => p.id === id);

  if (productIndex === -1) {
    // Return HTTP status code 404 when a product is not found
    return res.status(404).json({
      message: "Product not found"
    });
  }

  const { productName, price, quantity, category } = req.body;

  if (productName !== undefined) {
    cart[productIndex].productName = String(productName).trim();
  }

  if (price !== undefined) {
    const numPrice = Number(price);
    if (isNaN(numPrice) || numPrice < 0) {
      return res.status(400).json({
        message: "Invalid price: 'price' must be a non-negative number."
      });
    }
    cart[productIndex].price = numPrice;
  }

  if (quantity !== undefined) {
    const numQuantity = parseInt(quantity, 10);
    if (isNaN(numQuantity) || numQuantity <= 0) {
      return res.status(400).json({
        message: "Invalid quantity: 'quantity' must be a positive integer."
      });
    }
    cart[productIndex].quantity = numQuantity;
  }

  if (category !== undefined) {
    cart[productIndex].category = String(category).trim();
  }

  const updatedProduct = cart[productIndex];
  const totalPrice = updatedProduct.price * updatedProduct.quantity;

  // Return appropriate success response (page 6 sample)
  res.status(200).json({
    message: "Product updated successfully",
    product: {
      ...updatedProduct,
      totalPrice
    }
  });
});

// 5. DELETE /cart/:id - Remove a product from the cart
app.delete('/cart/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);

  if (isNaN(id)) {
    return res.status(400).json({
      message: "Invalid product ID: ID must be a valid integer."
    });
  }

  const productIndex = cart.findIndex(p => p.id === id);

  if (productIndex === -1) {
    // Return HTTP status code 404 when a product is not found
    return res.status(404).json({
      message: "Product not found"
    });
  }

  // Remove the product from the array
  const [removedProduct] = cart.splice(productIndex, 1);

  // Return appropriate success message (page 6 sample)
  res.status(200).json({
    message: "Product removed from cart successfully",
    product: removedProduct
  });
});

// 404 Error handler for undefined routes
app.use((req, res) => {
  res.status(404).json({
    error: "404 Not Found: The requested endpoint does not exist."
  });
});

// Global error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: "500 Internal Server Error"
  });
});

// Configure the application to listen on port 4000
app.listen(PORT, () => {
  console.log(`Express Server running at http://localhost:${PORT}`);
});
