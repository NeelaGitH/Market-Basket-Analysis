# Market-Basket-Analysis

I’ve built a complete Market Basket Analysis workflow using SQL and Power BI. I started by cleaning the raw transaction data from 2018–2019 (dataset link: https://www.kaggle.com/datasets/vipin20/transaction-data)

### What is Market Basket Analysis?

Market Basket Analysis helps identify products that are frequently bought together. The key metrics used are:

- **Support**: How often an itemset appears in the dataset.  
- **Confidence**: The likelihood that item Y is bought when item X is bought.  
- **Lift**: How much more likely Y is bought with X, compared to Y being bought independently. A lift > 1 shows positive correlation.

I wrote custom DAX in Power BI to calculate support, confidence, and lift. I used `CROSSJOIN` to generate all possible product pairs and identify frequent combinations.

After that, I designed a Power BI dashboard to show key insights—like total transactions, product count, and the strongest association rules.

The association rules are based on transaction data collected across 38 countries, making the insights globally relevant and diverse.
