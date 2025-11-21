#!/usr/bin/env python3
"""
D2L.ai Training Script for SageMaker
Demonstrates MLA-C01 concepts: Custom containers, training jobs, model registry
"""

import argparse
import os
import torch
import torch.nn as nn
import numpy as np
from kiwipiepy import Kiwi
import json

def parse_args():
    parser = argparse.ArgumentParser()
    
    # SageMaker specific arguments
    parser.add_argument('--model-dir', type=str, default=os.environ.get('SM_MODEL_DIR'))
    parser.add_argument('--train', type=str, default=os.environ.get('SM_CHANNEL_TRAIN'))
    parser.add_argument('--test', type=str, default=os.environ.get('SM_CHANNEL_TEST'))
    
    # Model hyperparameters
    parser.add_argument('--epochs', type=int, default=10)
    parser.add_argument('--batch-size', type=int, default=64)
    parser.add_argument('--lr', type=float, default=0.001)
    
    return parser.parse_args()

class SimpleNeuralNet(nn.Module):
    """Simple neural network following D2L.ai patterns"""
    def __init__(self, input_size=100, hidden_size=50, output_size=2):
        super().__init__()
        self.layers = nn.Sequential(
            nn.Linear(input_size, hidden_size),
            nn.ReLU(),
            nn.Linear(hidden_size, output_size),
            nn.Softmax(dim=1)
        )
    
    def forward(self, x):
        return self.layers(x)

def preprocess_korean_text(text):
    """Korean text preprocessing using Kiwi"""
    kiwi = Kiwi()
    result = kiwi.analyze(text)
    tokens = [token.form for token in result[0][0]]
    return ' '.join(tokens)

def train_model(args):
    """Training function following D2L.ai methodology"""
    
    # Set device (GPU if available)
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    print(f"Training on device: {device}")
    
    # Create model
    model = SimpleNeuralNet().to(device)
    
    # Sample training loop (would use real data in practice)
    optimizer = torch.optim.Adam(model.parameters(), lr=args.lr)
    criterion = nn.CrossEntropyLoss()
    
    print("Starting training...")
    for epoch in range(args.epochs):
        # Simulate training step
        dummy_input = torch.randn(args.batch_size, 100).to(device)
        dummy_target = torch.randint(0, 2, (args.batch_size,)).to(device)
        
        optimizer.zero_grad()
        output = model(dummy_input)
        loss = criterion(output, dummy_target)
        loss.backward()
        optimizer.step()
        
        if epoch % 2 == 0:
            print(f"Epoch {epoch}, Loss: {loss.item():.4f}")
    
    # Save model (SageMaker format)
    model_path = os.path.join(args.model_dir, 'model.pth')
    torch.save(model.state_dict(), model_path)
    
    # Save model metadata (for Model Registry)
    metadata = {
        'framework': 'pytorch',
        'd2l_version': '1.0.3',
        'korean_nlp': 'kiwi',
        'epochs': args.epochs,
        'batch_size': args.batch_size,
        'learning_rate': args.lr
    }
    
    with open(os.path.join(args.model_dir, 'metadata.json'), 'w') as f:
        json.dump(metadata, f)
    
    print(f"Model saved to {model_path}")
    return model

if __name__ == '__main__':
    args = parse_args()
    train_model(args)
