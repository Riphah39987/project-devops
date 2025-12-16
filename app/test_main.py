"""
Unit tests for the DevOps Sample Application
"""

import pytest
from fastapi.testclient import TestClient
from main import app, items_db

client = TestClient(app)

@pytest.fixture(autouse=True)
def clear_db():
    """Clear database before each test"""
    items_db.clear()
    yield
    items_db.clear()

def test_read_root():
    """Test root endpoint"""
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json()
    assert "version" in response.json()

def test_health_check():
    """Test health check endpoint"""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "timestamp" in data
    assert "version" in data

def test_create_item():
    """Test creating an item"""
    item_data = {
        "name": "Test Item",
        "description": "Test Description",
        "price": 99.99
    }
    response = client.post("/items", json=item_data)
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Test Item"
    assert data["price"] == 99.99
    assert "id" in data
    assert "created_at" in data

def test_list_items():
    """Test listing items"""
    # Create test items
    client.post("/items", json={"name": "Item 1", "price": 10.0})
    client.post("/items", json={"name": "Item 2", "price": 20.0})
    
    response = client.get("/items")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 2

def test_get_item():
    """Test getting a specific item"""
    # Create an item
    create_response = client.post("/items", json={"name": "Test Item", "price": 50.0})
    item_id = create_response.json()["id"]
    
    # Get the item
    response = client.get(f"/items/{item_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "Test Item"

def test_get_nonexistent_item():
    """Test getting a non-existent item"""
    response = client.get("/items/999")
    assert response.status_code == 404

def test_update_item():
    """Test updating an item"""
    # Create an item
    create_response = client.post("/items", json={"name": "Original", "price": 100.0})
    item_id = create_response.json()["id"]
    
    # Update the item
    update_data = {"name": "Updated", "price": 150.0}
    response = client.put(f"/items/{item_id}", json=update_data)
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "Updated"
    assert data["price"] == 150.0

def test_delete_item():
    """Test deleting an item"""
    # Create an item
    create_response = client.post("/items", json={"name": "To Delete", "price": 75.0})
    item_id = create_response.json()["id"]
    
    # Delete the item
    response = client.delete(f"/items/{item_id}")
    assert response.status_code == 200
    
    # Verify deletion
    get_response = client.get(f"/items/{item_id}")
    assert get_response.status_code == 404

def test_metrics():
    """Test metrics endpoint"""
    # Create some items
    client.post("/items", json={"name": "Item 1", "price": 10.0})
    client.post("/items", json={"name": "Item 2", "price": 20.0})
    
    response = client.get("/metrics")
    assert response.status_code == 200
    data = response.json()
    assert data["total_items"] == 2
    assert "app_version" in data
