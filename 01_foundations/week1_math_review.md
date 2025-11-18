# Week 1: Mathematics Review for Deep Learning 📐

## Overview
This document covers the essential mathematical concepts you need to understand before diving deep into neural networks.

## 📊 Linear Algebra Fundamentals

### Vectors and Matrices
- **Vector**: A list of numbers (e.g., [1, 2, 3])
- **Matrix**: A 2D array of numbers
- **Transpose**: Flipping rows and columns (A^T)
- **Dot Product**: Sum of element-wise multiplication

### Key Operations
```python
import numpy as np

# Vector operations
a = np.array([1, 2, 3])
b = np.array([4, 5, 6])
dot_product = np.dot(a, b)  # = 1*4 + 2*5 + 3*6 = 32

# Matrix operations
A = np.array([[1, 2], [3, 4]])
B = np.array([[5, 6], [7, 8]])
matrix_mult = np.dot(A, B)  # Matrix multiplication
```

### Why Important in Deep Learning?
- Neural networks are matrix multiplications
- Weights and inputs are matrices/vectors
- Gradients are computed using linear algebra

---

## 🧮 Calculus Essentials

### Derivatives
- **Definition**: Rate of change of a function
- **Chain Rule**: For composite functions f(g(x)), derivative is f'(g(x)) * g'(x)
- **Partial Derivatives**: Derivatives with respect to one variable

### Gradients
- **Gradient**: Vector of all partial derivatives
- **Used in**: Backpropagation, optimization
- **Direction**: Points toward steepest increase

### Common Derivatives in Deep Learning
```python
# Sigmoid: σ(x) = 1/(1 + e^(-x))
# Derivative: σ'(x) = σ(x)(1 - σ(x))

# ReLU: f(x) = max(0, x)  
# Derivative: f'(x) = 1 if x > 0, else 0

# MSE Loss: L = (y - ŷ)²
# Derivative: dL/dŷ = 2(ŷ - y)
```

---

## 📈 Probability and Statistics

### Basic Probability
- **Sample Space**: All possible outcomes
- **Event**: A subset of sample space
- **Probability**: P(A) = favorable outcomes / total outcomes

### Distributions
- **Normal Distribution**: Bell curve, common in nature
- **Bernoulli**: Binary outcomes (0 or 1)
- **Categorical**: Multiple discrete categories

### Why Important?
- Data often follows probability distributions
- Regularization uses probabilistic concepts
- Uncertainty quantification in predictions

---

## 🎯 Practice Exercises

### Exercise 1: Vector Operations
```python
# Implement dot product from scratch
def dot_product(a, b):
    return sum(a[i] * b[i] for i in range(len(a)))

# Test with [1, 2, 3] and [4, 5, 6]
# Expected result: 32
```

### Exercise 2: Matrix Multiplication
```python
# Implement matrix multiplication
def matrix_multiply(A, B):
    rows_A, cols_A = len(A), len(A[0])
    rows_B, cols_B = len(B), len(B[0])
    
    # Check if multiplication is possible
    if cols_A != rows_B:
        raise ValueError("Cannot multiply matrices")
    
    # Initialize result matrix
    result = [[0 for _ in range(cols_B)] for _ in range(rows_A)]
    
    # Perform multiplication
    for i in range(rows_A):
        for j in range(cols_B):
            for k in range(cols_A):
                result[i][j] += A[i][k] * B[k][j]
    
    return result
```

### Exercise 3: Derivative Calculation
```python
# Implement numerical derivative
def numerical_derivative(f, x, h=1e-5):
    return (f(x + h) - f(x - h)) / (2 * h)

# Test with f(x) = x²
# At x = 3, derivative should be 6
def square(x):
    return x**2

deriv = numerical_derivative(square, 3)
print(f"Derivative of x² at x=3: {deriv}")
```

## 🔗 Additional Resources

### Online Courses
- [3Blue1Brown Linear Algebra](https://www.youtube.com/playlist?list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab)
- [Khan Academy Calculus](https://www.khanacademy.org/math/calculus-1)
- [MIT OpenCourseWare](https://ocw.mit.edu/courses/mathematics/)

### Books
- "Linear Algebra Done Right" by Sheldon Axler
- "Calculus: Early Transcendentals" by Stewart
- "Introduction to Probability" by Blitzstein & Hwang

### Practice Platforms
- Brilliant.org
- Coursera Mathematics courses
- edX MIT courses

## ✅ Self-Assessment

Before moving to Week 2, ensure you can:
- [ ] Multiply matrices by hand
- [ ] Compute dot products
- [ ] Understand what a derivative means
- [ ] Apply the chain rule
- [ ] Recognize common probability distributions
- [ ] Implement basic operations in Python/NumPy

## Next: Week 2 - Machine Learning Basics
Once comfortable with these math concepts, proceed to `02_ml_basics/` to learn fundamental ML algorithms.