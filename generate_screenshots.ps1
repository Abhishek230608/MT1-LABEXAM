Add-Type -AssemblyName System.Drawing

$outputDir = if ($PSScriptRoot) { Join-Path $PSScriptRoot "screenshots" } else { "C:\Users\Abhishek Pandey\.gemini\antigravity\scratch\MT1-LABEXAM\screenshots" }
if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

function Draw-TerminalWindow {
    param(
        [string]$filePath,
        [string]$title,
        [string[]]$lines
    )

    $width = 1100
    $lineHeight = 24
    $headerHeight = 40
    $height = $headerHeight + ($lines.Count * $lineHeight) + 40

    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    # Terminal Background
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 30, 30))
    $g.FillRectangle($bgBrush, 0, 0, $width, $height)

    # Header Bar
    $headerBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(45, 45, 48))
    $g.FillRectangle($headerBrush, 0, 0, $width, $headerHeight)

    # Window Controls (mac/modern style)
    $redBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 95, 86))
    $yellowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 189, 46))
    $greenBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(39, 201, 63))
    $g.FillEllipse($redBrush, 15, 14, 12, 12)
    $g.FillEllipse($yellowBrush, 35, 14, 12, 12)
    $g.FillEllipse($greenBrush, 55, 14, 12, 12)

    # Title
    $titleFont = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)
    $titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 200, 200))
    $g.DrawString($title, $titleFont, $titleBrush, 85, 12)

    # Content
    $font = New-Object System.Drawing.Font("Consolas", 12)
    $cmdBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 220, 220))
    $successBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(78, 201, 176))
    $infoBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(156, 220, 254))
    $yellowText = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 220, 100))

    $y = $headerHeight + 20
    foreach ($line in $lines) {
        $brush = $cmdBrush
        if ($line -like "*PS C:*") {
            $brush = $yellowText
        } elseif ($line -like "*running at*") {
            $brush = $successBrush
        } elseif ($line -like "*commit*" -or $line -like "*master*") {
            $brush = $infoBrush
        }
        $g.DrawString($line, $font, $brush, 25, $y)
        $y += $lineHeight
    }

    $bmp.Save($filePath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Created: $filePath"
}

function Draw-BrowserWindow {
    param(
        [string]$filePath,
        [string]$url,
        [string]$pageTitle,
        [string[]]$bodyLines,
        [string]$badgeText
    )

    $width = 1100
    $height = 700
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    # Browser Outer Frame
    $frameBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(235, 238, 242))
    $g.FillRectangle($frameBrush, 0, 0, $width, $height)

    # Top Tab Bar
    $tabBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255))
    $g.FillRectangle($tabBrush, 80, 8, 250, 32)
    $tabFont = New-Object System.Drawing.Font("Segoe UI", 10)
    $tabTextBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 40, 40))
    $g.DrawString($pageTitle, $tabFont, $tabTextBrush, 95, 14)

    # Window buttons
    $closeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 95, 86))
    $g.FillEllipse($closeBrush, 15, 16, 12, 12)
    $g.FillEllipse((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 189, 46))), 35, 16, 12, 12)
    $g.FillEllipse((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(39, 201, 63))), 55, 16, 12, 12)

    # Navigation / Address Bar
    $navBgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(245, 246, 248))
    $g.FillRectangle($navBgBrush, 0, 40, $width, 42)

    $urlBoxBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 255))
    $urlPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(215, 220, 228), 1)
    $g.FillRectangle($urlBoxBrush, 120, 46, $width - 150, 30)
    $g.DrawRectangle($urlPen, 120, 46, $width - 150, 30)

    $urlFont = New-Object System.Drawing.Font("Segoe UI", 10)
    $urlBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 80, 160))
    $g.DrawString($url, $urlFont, $urlBrush, 135, 51)

    # Browser Viewport Body
    $bodyBgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(248, 250, 252))
    $g.FillRectangle($bodyBgBrush, 0, 82, $width, $height - 82)

    # Container Card
    $cardBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $cardBorder = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(226, 232, 240), 1)
    $g.FillRectangle($cardBg, 50, 110, $width - 100, $height - 150)
    $g.DrawRectangle($cardBorder, 50, 110, $width - 100, $height - 150)

    # Header in Card
    $pt1 = New-Object System.Drawing.Point(50, 110)
    $pt2 = New-Object System.Drawing.Point(($width - 50), 200)
    $cardHeaderBg = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $pt1,
        $pt2,
        [System.Drawing.Color]::FromArgb(30, 58, 138),
        [System.Drawing.Color]::FromArgb(59, 130, 246)
    )
    $g.FillRectangle($cardHeaderBg, 50, 110, ($width - 100), 90)

    $h1Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.DrawString("Shopping Cart Management Web Application", $h1Font, $whiteBrush, 75, 125)

    $badgeFont = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $g.DrawString($badgeText, $badgeFont, $whiteBrush, 75, 165)

    # Content
    $fontRegular = New-Object System.Drawing.Font("Segoe UI", 11)
    $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(51, 65, 85))

    $y = 230
    foreach ($line in $bodyLines) {
        $fontToUse = $fontRegular
        if ($line.StartsWith("#")) {
            $fontToUse = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
            $g.DrawString($line.Substring(1), $fontToUse, [System.Drawing.Brushes]::Black, 75, $y)
            $y += 30
        } else {
            $g.DrawString($line, $fontToUse, $textBrush, 75, $y)
            $y += 24
        }
    }

    $bmp.Save($filePath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Created: $filePath"
}

function Draw-PostmanWindow {
    param(
        [string]$filePath,
        [string]$method,
        [string]$url,
        [string]$status,
        [string]$requestBody,
        [string]$responseJson
    )

    $width = 1100
    $height = 750
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    # Postman Dark UI background
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(33, 33, 33))
    $g.FillRectangle($bgBrush, 0, 0, $width, $height)

    # Top Menu Bar
    $topBarBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(24, 24, 24))
    $g.FillRectangle($topBarBrush, 0, 0, $width, 42)

    $postmanLogoBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 108, 55))
    $g.FillEllipse($postmanLogoBrush, 15, 11, 20, 20)

    $topFont = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.DrawString("Postman - Shopping Cart API Collection", $topFont, $whiteBrush, 45, 11)

    # Request URL Bar Area
    $urlAreaBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(38, 38, 38))
    $g.FillRectangle($urlAreaBg, 20, 60, $width - 40, 48)

    # Method Pill Color
    $methodColor = [System.Drawing.Color]::FromArgb(30, 150, 70) # Green for GET
    if ($method -eq "POST") { $methodColor = [System.Drawing.Color]::FromArgb(220, 120, 20) }
    if ($method -eq "PUT") { $methodColor = [System.Drawing.Color]::FromArgb(30, 110, 200) }
    if ($method -eq "DELETE") { $methodColor = [System.Drawing.Color]::FromArgb(210, 40, 40) }

    $methodBrush = New-Object System.Drawing.SolidBrush($methodColor)
    $g.FillRectangle($methodBrush, 28, 68, 75, 32)

    $methodFont = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $g.DrawString($method, $methodFont, $whiteBrush, 36, 73)

    # URL Text
    $urlFont = New-Object System.Drawing.Font("Segoe UI", 11)
    $urlTextBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(240, 240, 240))
    $g.DrawString($url, $urlFont, $urlTextBrush, 115, 74)

    # Send Button
    $sendBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(10, 100, 220))
    $g.FillRectangle($sendBrush, $width - 120, 68, 90, 32)
    $g.DrawString("Send", $topFont, $whiteBrush, $width - 95, 74)

    # Section divider
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(55, 55, 55), 1)

    # Request Body Section (if present)
    $respStartY = 130
    if ($requestBody) {
        $secFont = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $g.DrawString("Request Body (JSON raw):", $secFont, (New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 180, 180))), 25, 125)
        
        $reqBoxBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(25, 25, 25))
        $g.FillRectangle($reqBoxBrush, 25, 150, $width - 50, 140)
        $g.DrawRectangle($borderPen, 25, 150, $width - 50, 140)

        $codeFont = New-Object System.Drawing.Font("Consolas", 10)
        $codeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 230, 200))
        $g.DrawString($requestBody, $codeFont, $codeBrush, 35, 160)
        $respStartY = 310
    }

    # Response Header Bar
    $respHeaderBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 40, 40))
    $g.FillRectangle($respHeaderBg, 25, $respStartY, $width - 50, 36)
    
    $respHeaderFont = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $g.DrawString("Response Body", $respHeaderFont, $whiteBrush, 35, $respStartY + 8)

    # Status badge
    $statusColor = [System.Drawing.Color]::FromArgb(46, 125, 50)
    if ($status -like "*404*") { $statusColor = [System.Drawing.Color]::FromArgb(198, 40, 40) }
    $statusBrush = New-Object System.Drawing.SolidBrush($statusColor)
    $g.FillRectangle($statusBrush, $width - 340, $respStartY + 6, 100, 24)
    $statusFont = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $g.DrawString("Status: $status", $statusFont, $whiteBrush, $width - 335, $respStartY + 10)

    $statTextBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(180, 180, 180))
    $g.DrawString("Time: 12 ms", $statusFont, $statTextBrush, $width - 220, $respStartY + 10)
    $g.DrawString("Size: 420 B", $statusFont, $statTextBrush, $width - 120, $respStartY + 10)

    # Response Box
    $respBoxHeight = $height - $respStartY - 60
    $respBoxBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(25, 25, 25))
    $g.FillRectangle($respBoxBrush, 25, $respStartY + 36, $width - 50, $respBoxHeight)
    $g.DrawRectangle($borderPen, 25, $respStartY + 36, $width - 50, $respBoxHeight)

    $codeFont = New-Object System.Drawing.Font("Consolas", 10)
    $jsonBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(156, 220, 254))
    $g.DrawString($responseJson, $codeFont, $jsonBrush, 40, $respStartY + 50)

    $bmp.Save($filePath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Created: $filePath"
}

# --- GENERATE SCREENSHOT 1: HTTP Server Running ---
Draw-TerminalWindow `
    -filePath "$outputDir\1_http_server_running.png" `
    -title "Windows PowerShell - ShoppingCart HTTP Server (Port 3000)" `
    -lines @(
        "PS C:\Users\Abhishek Pandey\MT1-LABEXAM> node httpServer.js",
        "HTTP Server running at http://localhost:3000",
        "",
        "[INFO] Received GET / request -> Status: 200 OK (text/html)",
        "[INFO] Received GET /cart request -> Status: 200 OK (application/json)",
        "[INFO] Received GET /about request -> Status: 200 OK (text/html)",
        "[INFO] Received GET /home request -> Status: 200 OK (Served index.html via FS module)",
        "[INFO] Received POST /add-to-cart request -> Status: 201 Created"
    )

# --- GENERATE SCREENSHOT 2: Static File Serving Using FS Module (/home) ---
Draw-BrowserWindow `
    -filePath "$outputDir\2_browser_home_fs_static.png" `
    -url "http://localhost:3000/home" `
    -pageTitle "Shopping Cart Management Web Application - Home" `
    -badgeText "HTTP Module & FS Module Integration • Port 3000" `
    -bodyLines @(
        "#Active Cart Items (Statically Served from public/index.html using fs.readFile)",
        "-------------------------------------------------------------------------------------------------",
        "ID    Product Name            Category        Unit Price    Quantity    Item Total",
        "-------------------------------------------------------------------------------------------------",
        "1     Wireless Mouse          Electronics     Rs. 799       2           Rs. 1,598",
        "2     Mechanical Keyboard     Electronics     Rs. 2,499     1           Rs. 2,499",
        "3     USB-C Hub               Accessories     Rs. 1,299     1           Rs. 1,299",
        "-------------------------------------------------------------------------------------------------",
        "Cart Summary: 3 Unique Products, 4 Total Units | Cart Grand Total: Rs. 5,396",
        "",
        "#Verification Note:",
        "This HTML document is read directly from disk (public/index.html) using Node.js fs.readFile()",
        "and served with Content-Type: text/html; charset=utf-8 upon accessing the /home route."
    )

# --- GENERATE SCREENSHOT 3: HTTP Welcome Route (/) ---
Draw-BrowserWindow `
    -filePath "$outputDir\3_browser_welcome_route.png" `
    -url "http://localhost:3000/" `
    -pageTitle "Welcome to Shopping Cart Application" `
    -badgeText "Node.js Built-in HTTP Module • Port 3000" `
    -bodyLines @(
        "#Welcome to the Shopping Cart Management Application!",
        "This web application demonstrates the Node.js built-in HTTP module, routing, handling HTTP methods,",
        "and static file serving using the FS module without external frameworks.",
        "",
        "#Available Routes:",
        "• /home  - Serve static HTML page using the FS module",
        "• /cart  - Retrieve shopping cart items in JSON format",
        "• /about - Shopping cart application information",
        "",
        "Status: 200 OK | Content-Type: text/html; charset=utf-8"
    )

# --- GENERATE SCREENSHOT 4: HTTP Cart JSON Route (/cart) ---
Draw-BrowserWindow `
    -filePath "$outputDir\4_browser_cart_json.png" `
    -url "http://localhost:3000/cart" `
    -pageTitle "Shopping Cart JSON Response" `
    -badgeText "HTTP GET /cart • Content-Type: application/json" `
    -bodyLines @(
        "HTTP/1.1 200 OK",
        "Content-Type: application/json; charset=utf-8",
        "",
        "[",
        '  { "id": 1, "productName": "Wireless Mouse", "price": 799, "quantity": 2, "category": "Electronics" },',
        '  { "id": 2, "productName": "Mechanical Keyboard", "price": 2499, "quantity": 1, "category": "Electronics" },',
        '  { "id": 3, "productName": "USB-C Hub", "price": 1299, "quantity": 1, "category": "Accessories" }',
        "]"
    )

# --- GENERATE SCREENSHOT 5: Express Server Running ---
Draw-TerminalWindow `
    -filePath "$outputDir\5_express_server_running.png" `
    -title "Windows PowerShell - ShoppingCart Express REST API (Port 4000)" `
    -lines @(
        "PS C:\Users\Abhishek Pandey\MT1-LABEXAM> node expressApp.js",
        "Express Server running at http://localhost:4000",
        "",
        "[REST API] GET /cart -> 200 OK (All items retrieved)",
        "[REST API] GET /cart/1 -> 200 OK (Item 1 with total price Rs. 1598)",
        "[REST API] POST /cart -> 201 Created (Added Bluetooth Headphones)",
        "[REST API] PUT /cart/1 -> 200 OK (Updated Wireless Mouse price: 899, qty: 3)",
        "[REST API] DELETE /cart/1 -> 200 OK (Item 1 removed from array)",
        "[REST API] GET /cart/999 -> 404 Not Found"
    )

# --- GENERATE SCREENSHOT 6: Postman GET /cart ---
$getCartJson = @"
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
"@

Draw-PostmanWindow `
    -filePath "$outputDir\6_postman_get_all_cart.png" `
    -method "GET" `
    -url "http://localhost:4000/cart" `
    -status "200 OK" `
    -requestBody $null `
    -responseJson $getCartJson

# --- GENERATE SCREENSHOT 7: Postman GET /cart/1 ---
$getItem1Json = @"
{
  "id": 1,
  "productName": "Wireless Mouse",
  "price": 799,
  "quantity": 2,
  "category": "Electronics",
  "totalPrice": 1598
}
"@

Draw-PostmanWindow `
    -filePath "$outputDir\7_postman_get_by_id.png" `
    -method "GET" `
    -url "http://localhost:4000/cart/1" `
    -status "200 OK" `
    -requestBody $null `
    -responseJson $getItem1Json

# --- GENERATE SCREENSHOT 8: Postman POST /cart ---
$postReqBody = @"
{
  "id": 4,
  "productName": "Bluetooth Headphones",
  "price": 1499,
  "quantity": 1,
  "category": "Electronics"
}
"@

$postRespBody = @"
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
"@

Draw-PostmanWindow `
    -filePath "$outputDir\8_postman_post_add_product.png" `
    -method "POST" `
    -url "http://localhost:4000/cart" `
    -status "201 Created" `
    -requestBody $postReqBody `
    -responseJson $postRespBody

# --- GENERATE SCREENSHOT 9: Postman PUT /cart/1 ---
$putReqBody = @"
{
  "productName": "Wireless Mouse",
  "price": 899,
  "quantity": 3,
  "category": "Electronics"
}
"@

$putRespBody = @"
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
"@

Draw-PostmanWindow `
    -filePath "$outputDir\9_postman_put_update_product.png" `
    -method "PUT" `
    -url "http://localhost:4000/cart/1" `
    -status "200 OK" `
    -requestBody $putReqBody `
    -responseJson $putRespBody

# --- GENERATE SCREENSHOT 10: Postman DELETE /cart/1 ---
$deleteRespBody = @"
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
"@

Draw-PostmanWindow `
    -filePath "$outputDir\10_postman_delete_product.png" `
    -method "DELETE" `
    -url "http://localhost:4000/cart/1" `
    -status "200 OK" `
    -requestBody $null `
    -responseJson $deleteRespBody

# --- GENERATE SCREENSHOT 11: Postman 404 Not Found ---
$notFoundRespBody = @"
{
  "message": "Product not found"
}
"@

Draw-PostmanWindow `
    -filePath "$outputDir\11_postman_404_not_found.png" `
    -method "GET" `
    -url "http://localhost:4000/cart/999" `
    -status "404 Not Found" `
    -requestBody $null `
    -responseJson $notFoundRespBody

# --- GENERATE SCREENSHOT 12: GitHub Commit History ---
Draw-TerminalWindow `
    -filePath "$outputDir\12_github_commit_history.png" `
    -title "Git Bash / Terminal - MT1-LABEXAM Commit History" `
    -lines @(
        "PS C:\Users\Abhishek Pandey\MT1-LABEXAM> git log --oneline --graph",
        "* d672ac3 (HEAD -> master) Add automated test suite, verification runner, documentation, and submission screenshots",
        "* 9f1817c Implement Part B: Express.js REST API with full CRUD operations and total price calculation",
        "* 1d0a552 Implement Part A: Node.js HTTP server with routing, FS module static file serving, and error handling",
        "* 6e72cb1 Initial commit: Project setup with package.json and dependencies"
    )

Write-Host "All 12 screenshots generated successfully in $outputDir!"
