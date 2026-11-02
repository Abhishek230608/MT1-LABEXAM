// Comprehensive Automated Verification Suite for MT1-LABEXAM
// Tests both Part A (httpServer.js on port 3000) and Part B (expressApp.js on port 4000)

const runTests = async () => {
  console.log('====================================================');
  console.log('      MT1 LAB EXAM AUTOMATED VERIFICATION SUITE     ');
  console.log('====================================================\n');

  let passed = 0;
  let failed = 0;

  const assert = (condition, description, detail = '') => {
    if (condition) {
      console.log(`  [PASS] ${description}`);
      passed++;
    } else {
      console.error(`  [FAIL] ${description} -> ${detail}`);
      failed++;
    }
  };

  // Helper fetch function
  const request = async (url, options = {}) => {
    try {
      const res = await fetch(url, options);
      const contentType = res.headers.get('content-type') || '';
      let body;
      if (contentType.includes('application/json')) {
        body = await res.json();
      } else {
        body = await res.text();
      }
      return { status: res.status, headers: res.headers, body };
    } catch (err) {
      return { error: err.message };
    }
  };

  // --- PART A TESTS (httpServer.js on port 3000) ---
  console.log('--- TESTING PART A: Node.js HTTP Module Server (Port 3000) ---');

  // Test A1: GET / (Welcome HTML)
  const rootRes = await request('http://localhost:3000/');
  assert(rootRes.status === 200, 'GET / returns HTTP 200', `Got status ${rootRes.status}`);
  assert(typeof rootRes.body === 'string' && rootRes.body.includes('Welcome'), 'GET / returns HTML welcome message');

  // Test A2: GET /cart (JSON cart items)
  const cartRes = await request('http://localhost:3000/cart');
  assert(cartRes.status === 200, 'GET /cart returns HTTP 200', `Got status ${cartRes.status}`);
  assert(Array.isArray(cartRes.body) && cartRes.body.length >= 3, 'GET /cart returns an array with initial items');

  // Test A3: GET /about (App Info)
  const aboutRes = await request('http://localhost:3000/about');
  assert(aboutRes.status === 200, 'GET /about returns HTTP 200', `Got status ${aboutRes.status}`);
  assert(typeof aboutRes.body === 'string' && aboutRes.body.includes('Shopping Cart'), 'GET /about returns app information');

  // Test A4: GET /home (Static index.html via FS module)
  const homeRes = await request('http://localhost:3000/home');
  assert(homeRes.status === 200, 'GET /home returns HTTP 200 (FS module static serve)', `Got status ${homeRes.status}`);
  assert(typeof homeRes.body === 'string' && homeRes.body.includes('Active Cart Items'), 'GET /home serves valid HTML content');

  // Test A5: POST /add-to-cart (Add item)
  const postItemRes = await request('http://localhost:3000/add-to-cart', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      id: 10,
      productName: 'Gaming Mouse Pad',
      price: 499,
      quantity: 1,
      category: 'Accessories'
    })
  });
  assert(postItemRes.status === 201, 'POST /add-to-cart returns HTTP 201', `Got status ${postItemRes.status}`);
  assert(postItemRes.body.product && postItemRes.body.product.id === 10, 'POST /add-to-cart successfully adds product');

  // Test A6: POST /add-to-cart Validation Error
  const postInvalidRes = await request('http://localhost:3000/add-to-cart', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ productName: 'Incomplete Item' })
  });
  assert(postInvalidRes.status === 400, 'POST /add-to-cart with missing fields returns HTTP 400', `Got status ${postInvalidRes.status}`);

  // Test A7: 404 Error handling
  const notFoundRes = await request('http://localhost:3000/non-existent-route');
  assert(notFoundRes.status === 404, 'Invalid route returns HTTP 404', `Got status ${notFoundRes.status}`);

  console.log('\n--- TESTING PART B: Express.js REST API (Port 4000) ---');

  // Test B1: GET /cart (Retrieve all items)
  const expCartRes = await request('http://localhost:4000/cart');
  assert(expCartRes.status === 200, 'GET /cart returns HTTP 200', `Got status ${expCartRes.status}`);
  assert(Array.isArray(expCartRes.body) && expCartRes.body.length >= 3, 'GET /cart returns array of at least 3 items');
  assert(expCartRes.body[0].totalPrice !== undefined, 'GET /cart includes calculated totalPrice (price * quantity)');

  // Test B2: GET /cart/:id (Retrieve item by ID)
  const expItem1Res = await request('http://localhost:4000/cart/1');
  assert(expItem1Res.status === 200, 'GET /cart/1 returns HTTP 200', `Got status ${expItem1Res.status}`);
  assert(expItem1Res.body.id === 1 && expItem1Res.body.totalPrice === expItem1Res.body.price * expItem1Res.body.quantity,
    'GET /cart/1 returns matching item and correct totalPrice calculation');

  // Test B3: GET /cart/:id Not Found
  const expItemNotFound = await request('http://localhost:4000/cart/999');
  assert(expItemNotFound.status === 404, 'GET /cart/999 returns HTTP 404', `Got status ${expItemNotFound.status}`);

  // Test B4: POST /cart (Add new product - exactly matching PDF specification on Page 5)
  const expPostRes = await request('http://localhost:4000/cart', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      id: 4,
      productName: 'Bluetooth Headphones',
      price: 1499,
      quantity: 1,
      category: 'Electronics'
    })
  });
  assert(expPostRes.status === 201, 'POST /cart returns HTTP 201 Created', `Got status ${expPostRes.status}`);
  assert(expPostRes.body.message === 'Product added successfully', 'POST /cart returns expected message');
  assert(expPostRes.body.product && expPostRes.body.product.id === 4, 'POST /cart returns created product');

  // Test B5: PUT /cart/:id (Update product details - exactly matching PDF specification on Page 6)
  const expPutRes = await request('http://localhost:4000/cart/1', {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      productName: 'Wireless Mouse',
      price: 899,
      quantity: 3,
      category: 'Electronics'
    })
  });
  assert(expPutRes.status === 200, 'PUT /cart/1 returns HTTP 200', `Got status ${expPutRes.status}`);
  assert(expPutRes.body.message === 'Product updated successfully', 'PUT /cart/1 returns update message');
  assert(expPutRes.body.product.price === 899 && expPutRes.body.product.quantity === 3, 'PUT /cart/1 correctly updates properties');

  // Test B6: DELETE /cart/:id (Delete product - exactly matching PDF specification on Page 6)
  const expDeleteRes = await request('http://localhost:4000/cart/1', {
    method: 'DELETE'
  });
  assert(expDeleteRes.status === 200, 'DELETE /cart/1 returns HTTP 200', `Got status ${expDeleteRes.status}`);
  assert(expDeleteRes.body.message === 'Product removed from cart successfully', 'DELETE /cart/1 returns success message');

  // Test B7: Verification of DELETE (GET /cart/1 should now be 404)
  const expAfterDelete = await request('http://localhost:4000/cart/1');
  assert(expAfterDelete.status === 404, 'GET /cart/1 after deletion returns HTTP 404', `Got status ${expAfterDelete.status}`);

  // Test B8: PUT on non-existent item returns 404
  const expPutNotFound = await request('http://localhost:4000/cart/999', {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ price: 100 })
  });
  assert(expPutNotFound.status === 404, 'PUT /cart/999 returns HTTP 404', `Got status ${expPutNotFound.status}`);

  // Test B9: DELETE on non-existent item returns 404
  const expDeleteNotFound = await request('http://localhost:4000/cart/999', {
    method: 'DELETE'
  });
  assert(expDeleteNotFound.status === 404, 'DELETE /cart/999 returns HTTP 404', `Got status ${expDeleteNotFound.status}`);

  console.log('\n====================================================');
  console.log(`TEST SUMMARY: ${passed} Passed, ${failed} Failed`);
  console.log('====================================================');

  if (failed > 0) {
    process.exit(1);
  } else {
    console.log('ALL LAB EXAM REQUIREMENTS PASSED WITH 100% SUCCESS!');
  }
};

runTests();
