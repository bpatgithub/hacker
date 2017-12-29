# Project Title

Nearest neighbor algorithm classifies different objects in logical grouping based on distance from the center. K-nearest neighbor (kNN) means objects are grouped among K nearest neighbors.  The distance can be any metric measure.  The standard Euclidean distance is the most common choice for measuring the distance.
 (image from Wikipedia)
Here, the green circle is the test sample which should be classified.  If k = 3, it will be classified among other objects presented by solid line circle.  If k = 5, it will be classified among other objects presented by dotted line circle.
The dataset consists of famous people from Wikipedia and contains around 50,000 famous individuals. We will create a cluster for the group of people based on affinity.  We will go through unsupervised learning, as we don't have a label for each cluster.
We will use TF-IDF document representation. At a high level, same words appearing in one document (e.g. the) should have less weighting compare to the word appearing across different documents.
The TF (Term Frequency) is counted by the number of times the word appears.
IDF (Inverse Document Frequency) uses log function for inverse frequency.

A larger number of doc with the same word approaches to log 1 which is close to zero.  A smaller number of doc with the same word approaches to log (low value) which is a larger value.

## Getting Started

### Testing

## Authors

* **Bhavesh Patel**

## License

## Acknowledgments

University of Washington
