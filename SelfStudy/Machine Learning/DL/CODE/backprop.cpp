#include <iostream>
#include <vector>

using namespace std;

// Function to compute Mean Squared Error Loss
double compute_loss(const vector<double>& y_pred, const vector<double>& y_true) {
    double loss = 0.0;
    for (size_t i = 0; i < y_pred.size(); i++)
        loss += (y_pred[i] - y_true[i]) * (y_pred[i] - y_true[i]);
    return loss / y_pred.size();
}

// Function to train a simple 1-layer neural network using backpropagation
void train(vector<double>& W, double& b, const vector<double>& X, const vector<double>& Y, double learning_rate, int epochs) {
    for (int epoch = 0; epoch < epochs; epoch++) {
        vector<double> y_pred(X.size());

        // Forward pass: Compute predictions
        for (size_t i = 0; i < X.size(); i++)
            y_pred[i] = W[0] * X[i] + b;

        // Compute loss
        double loss = compute_loss(y_pred, Y);

        // Compute gradients (backpropagation)
        double dW = 0.0, db = 0.0;
        for (size_t i = 0; i < X.size(); i++) {
            double error = y_pred[i] - Y[i];
            dW += 2 * X[i] * error;  // Gradient for weight
            db += 2 * error;         // Gradient for bias
        }

        dW /= X.size();  // Average gradient
        db /= X.size();

        // Update weights using gradient descent
        W[0] -= learning_rate * dW;
        b -= learning_rate * db;

        // Print loss every 10 epochs
        if (epoch % 10 == 0)
            cout << "Epoch " << epoch << " Loss: " << loss << endl;
    }
}

int main() {
    vector<double> X = {1.0, 2.0, 3.0, 4.0};  // Inputs
    vector<double> Y = {2.0, 4.0, 6.0, 8.0};  // Targets

    vector<double> W = {0.1};  // Initialize weight
    double b = 0.0;  // Initialize bias
    double learning_rate = 0.01;
    int epochs = 100;

    train(W, b, X, Y, learning_rate, epochs);

    cout << "Final weight: " << W[0] << ", Final bias: " << b << endl;

    return 0;
}
