# Authentication API - Test Cases

## 1. Register (`POST /api/v1/auth/register`)

### ✅ Success Cases (201 CREATED)

**1. Customer (Explicit Role):**
```json
{
  "name": "user1",
  "email": "user1@gmail.com",
  "password": "@User@1234",
  "system_role": "customer"
}
```
**2. Default Role (Customer):**

```json
{
  "name": "user2",
  "email": "user2@gmail.com",
  "password": "@User@1234"
}
```

**3. Artist Role:**

```JSON
{
  "name": "Artist1",
  "email": "artist@gmail.com",
  "password": "@Artist@123",
  "system_role": "artist"
}
```
**Success Response:**

```JSON
{
  "access_token": "eyJhbG...",
  "message": "User registered successfully",
  "refresh_token": "eyJhbG..."
}
```

### ❌ Failure Cases (400 BAD REQUEST)
**1. Duplicate User:**
```
{"error": "User already exists"}
```
**2. Missing Fields (e.g., empty password):** 
```
{"error": "Missing required fields"}
```

**3. Invalid Role (e.g., "admin"):** 
```
{"error": "Invalid registration role. Allowed roles are: customer, artist"}
```

**4. Invalid Domain (e.g., "@lalalla.com"):** 
```
{"error": "The domain name lalalla.com does not exist."}
```

**5. Weak Password:**
```
 {"error": "Password must be at least 8 characters long and include an uppercase letter, a lowercase letter, a number, and a special character."}
 ```

## 2. Login (POST /api/v1/auth/login)
### ✅ Success Cases (200 OK)

**Payload:**

```JSON
{
  "email": "user2@gmail.com",
  "password": "@User@1234"
}
```

**Response:**

```JSON
{
  "access_token": "eyJhbG...",
  "message": "Login successful",
  "refresh_token": "eyJhbG..."
}
```

### ❌ Failure Cases (401 UNAUTHORIZED)
**1. Wrong Password:**
```
 {"error": "Invalid email or password"}
```

**2. Email Not Found:** 
```
{"error": "Invalid email or password"}
```

## 3. Token Refresh (POST /api/v1/auth/refresh)
### ✅ Success Case (200 OK)
**Header: Authorization: Bearer <refresh_token>**

**Response:**

```JSON
{
  "access_token": "eyJhbG..."
}
```

### ❌ Failure Case (422 UNPROCESSABLE ENTITY)
**1. Using Access Token instead of Refresh Token:**

**Response:**
```
 {"msg": "Only refresh tokens are allowed"}
```

## 4. Logout (POST /api/v1/auth/logout)
### ✅ Success Case (200 OK)
**Header: Authorization: Bearer <access_token>**

Response:

```JSON
{
  "message": "Logged out successfully and notifications disabled for this device."
}
```
### ❌ Failure Cases
**1. No Token Provided (401 UNAUTHORIZED):**

```
{"msg": "Missing Authorization Header"}
```

**2. Using Refresh Token instead of Access Token (422 UNPROCESSABLE ENTITY):**

```
{"msg": "Only non-refresh tokens are allowed"}
```

**3. Fake/Tampered Token (422 UNPROCESSABLE ENTITY):**
```
{"msg": "Signature verification failed"}
```