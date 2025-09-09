# Code Challenge (Server Side)

## Installation Guide

Ensure you have the following installed:

- **Ruby**: 3.3.6
- **Rails**: 8.0.2.1 (API mode)

## Getting Started

### Install dependencies

Make sure you have Ruby installed, then install gems:

```cmd
bundle install
```

### Setup database

Run migrations and seed initial data:

```cmd
db:migrate
db:seed
```

> [!TIP]
> Seeds include default products (`GR1`, `SR1`, `CF1`) and pricing rules (BOGO, bulk discount, percentage discount).

### Setup database

```cmd
rails server
```

The API will be available at: `http://localhost:3000`

### Run tests

The app uses RSpec for testing:

```cmd
bundle exec rspec
```

**Expected**:

```cmd
..............

Finished in 0.11744 seconds (files took 0.51217 seconds to load)
14 examples, 0 failure
```

## API Endpoints

### GET /products

Returns all available products.

**Response**:

```json
[
  { "id": 1, "code": "GR1", "name": "Green Tea", "price": 3.11 },
  { "id": 2, "code": "SR1", "name": "Strawberries", "price": 5.0 },
  { "id": 3, "code": "CF1", "name": "Coffee", "price": 11.23 }
]
```

### GET /rules

Returns all pricing rules currently active.

**Response**:

```json
[
  { "applies_to": "GR1", "description": "Buy-One-Get-One-Free for Green Tea" },
  { "applies_to": "SR1", "description": "Bulk discount if 3+ Strawberries" },
  {
    "applies_to": "CF1",
    "description": "Bulk percentage discount if 3+ Coffees"
  }
]
```

### POST /checkout/scan

Scans (adds) a product into the current checkout cart.

**Request**:

```json
{ "code": "CF1" }
```

**Response**:

```json
{ "message": "Added CF1" }
```

### GET /checkout

Shows the current basket items and the total (with discounts applied).

**Response**:

```json
{
  "items": [{ "code": "CF1", "name": "Coffee", "price": 11.23, "quantity": 3 }],
  "total": "22.46€"
}
```

### DELETE /checkout

Clears the current cart.

**Response**:

```json
{ "message": "Checkout cleared" }
```

## Example Workflow

### Add 3 coffees:

```cmd
curl -X POST http://localhost:3000/checkout/scan -d "code=CF1"
curl -X POST http://localhost:3000/checkout/scan -d "code=CF1"
curl -X POST http://localhost:3000/checkout/scan -d "code=CF1"
```

### View checkout:

```cmd
curl http://localhost:3000/checkout
```

**Expected**:

```json
{
  "items": [{ "code": "CF1", "name": "Coffee", "price": 11.23, "quantity": 3 }],
  "total": "22.46€"
}
```

### Clear checkout:

```cmd
curl -X DELETE http://localhost:3000/checkout
```
