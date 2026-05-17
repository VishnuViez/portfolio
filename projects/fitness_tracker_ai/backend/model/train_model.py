"""
TensorFlow model for workout recommendation scoring.

This model learns user-exercise affinity based on workout history:
- Input: User features (age, weight, fitness_level) + Exercise features (muscle_group, intensity)
- Output: Predicted suitability score (0-1)

In production, this would be trained on real user data.
For demo purposes, we generate synthetic training data.
"""

import numpy as np

try:
    import tensorflow as tf
    from tensorflow import keras
    HAS_TF = True
except ImportError:
    HAS_TF = False
    print("TensorFlow not installed. Using rule-based recommendations.")


# Feature encoding maps
MUSCLE_GROUPS = ["Chest", "Back", "Legs", "Shoulders", "Arms", "Core", "Full Body"]
FITNESS_LEVELS = ["beginner", "intermediate", "advanced"]
FITNESS_GOALS = ["build_muscle", "lose_weight", "endurance", "general_fitness"]
CATEGORIES = ["Strength", "Bodyweight", "Cardio", "HIIT", "Core"]


def encode_features(user_age, user_weight, fitness_level, fitness_goal,
                    exercise_category, muscle_group, exercise_intensity):
    """Encode raw features into numeric vector for the model."""
    level_enc = [0] * len(FITNESS_LEVELS)
    if fitness_level in FITNESS_LEVELS:
        level_enc[FITNESS_LEVELS.index(fitness_level)] = 1

    goal_enc = [0] * len(FITNESS_GOALS)
    if fitness_goal in FITNESS_GOALS:
        goal_enc[FITNESS_GOALS.index(fitness_goal)] = 1

    cat_enc = [0] * len(CATEGORIES)
    if exercise_category in CATEGORIES:
        cat_enc[CATEGORIES.index(exercise_category)] = 1

    muscle_enc = [0] * len(MUSCLE_GROUPS)
    if muscle_group in MUSCLE_GROUPS:
        muscle_enc[MUSCLE_GROUPS.index(muscle_group)] = 1

    return [
        user_age / 60.0,
        user_weight / 120.0,
        exercise_intensity / 10.0,
        *level_enc,
        *goal_enc,
        *cat_enc,
        *muscle_enc,
    ]


def generate_synthetic_data(n_samples=5000):
    """Generate synthetic training data based on fitness domain knowledge."""
    rng = np.random.default_rng(42)
    X, y = [], []

    for _ in range(n_samples):
        age = rng.integers(18, 55)
        weight = rng.integers(50, 110)
        level = rng.choice(FITNESS_LEVELS)
        goal = rng.choice(FITNESS_GOALS)
        category = rng.choice(CATEGORIES)
        muscle = rng.choice(MUSCLE_GROUPS)
        intensity = rng.uniform(1, 10)

        features = encode_features(age, weight, level, goal, category, muscle, intensity)

        # Rule-based scoring to train on
        score = 0.5
        if goal == "build_muscle" and category == "Strength":
            score += 0.2
        if goal == "lose_weight" and category in ("Cardio", "HIIT"):
            score += 0.25
        if goal == "endurance" and category in ("Cardio", "Bodyweight"):
            score += 0.2
        if level == "beginner" and intensity > 7:
            score -= 0.15
        if level == "advanced" and intensity < 4:
            score -= 0.1
        score += rng.normal(0, 0.05)
        score = np.clip(score, 0, 1)

        X.append(features)
        y.append(score)

    return np.array(X, dtype=np.float32), np.array(y, dtype=np.float32)


def build_model(input_dim):
    """Build a simple neural network for exercise scoring."""
    if not HAS_TF:
        return None

    model = keras.Sequential([
        keras.layers.Dense(64, activation="relu", input_shape=(input_dim,)),
        keras.layers.Dropout(0.2),
        keras.layers.Dense(32, activation="relu"),
        keras.layers.Dropout(0.1),
        keras.layers.Dense(16, activation="relu"),
        keras.layers.Dense(1, activation="sigmoid"),
    ])

    model.compile(optimizer="adam", loss="mse", metrics=["mae"])
    return model


def train_and_save():
    """Train the model and save to disk."""
    if not HAS_TF:
        print("Skipping training — TensorFlow not available.")
        return

    print("Generating synthetic training data...")
    X, y = generate_synthetic_data(10000)

    print(f"Training data shape: X={X.shape}, y={y.shape}")
    model = build_model(X.shape[1])

    print("Training model...")
    model.fit(X, y, epochs=50, batch_size=32, validation_split=0.2, verbose=1)

    model.save("fitness_recommender.keras")
    print("Model saved to fitness_recommender.keras")


if __name__ == "__main__":
    train_and_save()
