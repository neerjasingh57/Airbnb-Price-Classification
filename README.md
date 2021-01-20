# Airbnb-Price-Classification

**Summary**

Developed classification tool to help Airbnb hosts price rentals, using machine learning classification models in R (k-NN, Naive Bayes, Random Forest, Logistic Regression, and SVM) with Kaggle NYC Airbnb Open Data. Obtained the best AUC of 0.9 using the Random Forest model.

**Background**

Last semester, for our Data Science course, my team created an algorithm to predict and recommend, for Airbnb Hosts, in which price range they should categorize their Airbnb based on the Airbnb's general features such as neighborhood, room type, availability, and number of reviews. For this project, we used a dataset from Kaggle with info about Airbnbs in NYC in 2019 and tested five different predictive models: k-NN, Naïve-Bayes, SVM, Random Forest, and Logistic Regression to find the optimal algorithm.

**Methodology**

The data set consisted of about 48000 values and 16 variables. First, because there were missing values in the variable 'reviews_per_month' we inserted 0 into these values because we found that they were only missing when another variable, 'total number of reviews', was 0. We then split our variable price into a 'low range' and 'high range' using the first and fourth quartiles respectively. The first quartile were values below $70 per night and the fourth quartile were values above $175 per night. Additionally, the original dataset contained the latitude and longitude of each listing, so in order to understand the effect of location of an Airbnb on its price, we created a new variable representing the distance from Times Square.

We then separated the dataset into testing and training with random sampling of 80% observations as the training and 20% as the testing and standardized all the variables.

https://www.kaggle.com/dgomonov/new-york-city-airbnb-open-data

**Descriptive Statistics**

Taking a first look at the basic descriptives of our dataset, we found that, out of all the Boroughs contained in the dataset: the Bronx, Brooklyn, Manhattan, Queens, and Staten Island, Manhattan had the highest median price per Airbnb overall. However, the majority of these (80%) of these Airbnb listings were in Brooklyn or Manhattan. Furthermore, 50% of the listings were located within 2.76 miles of Times Square.

**ANALYSIS**

*Budget-friendly Classification*

After running all 5 classification models to identify budget-friendly apartments (<$70 per night) these were our results:

While the k-NN model had the highest AUC at .91, Random Forest also received a high AUC of.907 with the highest values overall for Accuracy, Recall, Precision, and the F1 Score. Our k-NN model's error count was the lowest with k = 25 and, for Random Forest, ntrees = 50. Due to these results, we selected Random Forest as the best performing model when incorporating the variables neighborhood group, room type, the number of minimum nights, the number of reviews, the number of listings a host has, availability, and distance from Times Square. Using Random Forest, we were also able to analyze feature importance and found that room type and distance from Times Square were the most important features that had the highest impact on price. 

*High-end Classification*

After running all 5 classification models to identify high-end apartments (>$175 per night) these were our results:

According to our results, the highest performing models were again k-NN and Random Forest as k-NN received the highest AUC at .862 and Random Forest received the highest values of accuracy, recall, and precision. For these models, k was set equal to 16 and ntrees was at 50. To select between classifier, because, we would like to err more on the side of the algorithm classifying Airbnbs at a lower price category rather than a higher price category, we selected Random Forest. This is because k-NN receives fewer false negatives than RF (Recall is higher) so we will allow for more false negatives at a higher price. 

Again for feature selection, the same indicators as for budget-friendly classification were the most relevant, room type and distance from Times Square.

**Conclusion**

Due to the overall strength of Random Forest as a classifier of low-end or high-end classification, we recommend Airbnb use this algorithm, along with the predictors we selected to assist hosts when they determine the price category of their Airbnb. When conducting future analysis, it would definitely be helpful to have some additional knowledge of square footage or possible extra amenities/services to further the accuracy of our classifier. Additionally, we did not necessarily address the 2nd and 3rd price quartiles and their classification (most likely mid-range) during this project due to time constraints, however this would be a logical next step in the process to further develop our algorithm.

