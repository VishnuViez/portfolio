# FitAI Backend

Python Flask API with TensorFlow-based workout recommendation engine.

## Tech Stack
- **Framework**: Flask 3.1
- **ML/AI**: TensorFlow 2.18, scikit-learn
- **CORS**: Flask-CORS

## Setup

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Train the Model (Optional)

```bash
python model/train_model.py
```

This generates synthetic fitness data and trains a neural network for exercise scoring.

## Run

```bash
python app.py
```

Server starts at `http://localhost:5000`.

## API Endpoints

### `GET /api/health`
Health check.

### `POST /api/recommend`
Get AI workout recommendation.

**Request:**
```json
{
  "user_profile": {"age": 26, "weight": 75, "fitnessLevel": "intermediate", "fitnessGoal": "Build Muscle"},
  "recent_sessions": [...],
  "focus_area": "Chest"
}
```

**Response:**
```json
{
  "id": "rec_20260320...",
  "title": "Chest Focus - Standard Plan",
  "exercises": [...],
  "confidence": 0.87
}
```

### `POST /api/analyze`
Analyze workout progress.
