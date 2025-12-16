"""
DevOps Multi-Cloud Sample Application
A FastAPI-based microservice demonstrating CI/CD best practices
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
import os
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="DevOps Sample API",
    description="Multi-cloud microservice with CI/CD pipeline",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Data models
class Item(BaseModel):
    id: Optional[int] = None
    name: str
    description: Optional[str] = None
    price: float
    created_at: Optional[datetime] = None

class HealthResponse(BaseModel):
    status: str
    timestamp: datetime
    version: str
    environment: str

# In-memory storage (replace with database in production)
items_db: List[Item] = []
item_counter = 1

# Routes
@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "DevOps Multi-Cloud Sample Application",
        "version": "1.0.0",
        "docs": "/docs"
    }

@app.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint for monitoring"""
    return HealthResponse(
        status="healthy",
        timestamp=datetime.now(),
        version="1.0.0",
        environment=os.getenv("ENVIRONMENT", "development")
    )

@app.get("/items", response_model=List[Item])
async def list_items():
    """List all items"""
    return items_db

@app.get("/items/{item_id}", response_model=Item)
async def get_item(item_id: int):
    """Get a specific item by ID"""
    for item in items_db:
        if item.id == item_id:
            return item
    raise HTTPException(status_code=404, detail="Item not found")

@app.post("/items", response_model=Item, status_code=201)
async def create_item(item: Item):
    """Create a new item"""
    global item_counter
    item.id = item_counter
    item.created_at = datetime.now()
    items_db.append(item)
    item_counter += 1
    logger.info(f"Created item: {item.name} (ID: {item.id})")
    return item

@app.put("/items/{item_id}", response_model=Item)
async def update_item(item_id: int, updated_item: Item):
    """Update an existing item"""
    for idx, item in enumerate(items_db):
        if item.id == item_id:
            updated_item.id = item_id
            updated_item.created_at = item.created_at
            items_db[idx] = updated_item
            logger.info(f"Updated item ID: {item_id}")
            return updated_item
    raise HTTPException(status_code=404, detail="Item not found")

@app.delete("/items/{item_id}")
async def delete_item(item_id: int):
    """Delete an item"""
    for idx, item in enumerate(items_db):
        if item.id == item_id:
            items_db.pop(idx)
            logger.info(f"Deleted item ID: {item_id}")
            return {"message": "Item deleted successfully"}
    raise HTTPException(status_code=404, detail="Item not found")

@app.get("/metrics")
async def metrics():
    """Application metrics endpoint"""
    return {
        "total_items": len(items_db),
        "app_version": "1.0.0",
        "uptime": "N/A"  # Would implement actual uptime tracking
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000, log_level="info")
