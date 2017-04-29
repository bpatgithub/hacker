# Project Title

regression analysis:  One of the most common statistical algorithm used in machine learning problems.

Regression analysis is a basic method used in statistical analysis of data. It’s a statistical method which allows estimating the relationships among variables. One needs to identify dependent variable which will vary based on the value of the independent variable. For example, the value of the house (dependent variable) varies based on square feet of the house (independent variable). Regression analysis is very useful tool in predictive analytics.
E(Y | X) = f(X, β)
STATISTICS BEHIND THE ANALYSIS

Y = f(X) = 𝛽0 + 𝛽1 * X
𝛽0 is the intercept of the line
𝛽1 is the slope of the line
Linear regression algorithm is used to predict the relationship(line) among data points.  There can be many different (linear or nonlinear) ways to define the relationship.  In the linear model, it is based on the intercept and the slope.  To find out the most optimal relationship, we need to train the model with the data.

Before applying the linear regression model, we should determine whether or not there is a relationship between the variables of interest.  A scatterplot is a good starting point to help in determining the strength of the relationship between two variables.  The correlation coefficient is a valuable measure of association between variables.  Its value varies between -1 (weak relationship) and 1 (strong relationship).

Once we determine that there is a relationship between variables, next step is to identify best-fitting relationship (line) between the variables.  The most common method is the Residual Sum of Squares (RSS).  This method calculates the difference between observed data (actual value) and its vertical distance from the proposed best-fitting line (predicted value).  It squares each difference and adds all of them.

The MSE (Mean Squared Error) is a quality measure for the estimator by dividing RSS by total observed data points.  It is always a non-negative number.  Values closer to zero represent a smaller error.  The RMSE (Root Mean Squared Error) is the square root of the MSE.  The RMSE is a measure of the average deviation of the estimates from the observed values.  This is easier to observe compare to MSE, which can be a large number.

## Getting Started

### Testing

## Authors

* **Bhavesh Patel**

## License

## Acknowledgments

University of Washington
