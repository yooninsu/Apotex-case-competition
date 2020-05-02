#first, your label (deciding parameter) must be binary
set.seed(112233) ##for reproducible results
require(xgboost)
library(xgboost)
dt1 <- final_data
dt1$customer_response <- ifelse(dt1$customer_response == "Won",1,0)
sample <- sample.int(n = nrow(dt1), size = floor(.75*nrow(dt1)), replace = F)
traindt <- dt1[sample,]
testdt <- dt1[-sample,]
dtrain <- xgb.DMatrix(as.matrix(sapply(traindt[-1], as.numeric)), label=traindt$customer_response)
dtest <- xgb.DMatrix(as.matrix(sapply(testdt[-1], as.numeric)), label=testdt$customer_response)
##sample is divided into 75% traindata, 25% test data
  # sample is transformed to 'xgb.DMatrix' format required for xgb to learn from
#basic training starts here
# 1. generating dense matrix of 
basic_model <- xgboost(data = dtrain, max.depth = 5, eta = 1, nthread = 2, nrounds = 3, objective = "binary:logistic")
# 2. Prediction using basic model
pred <- predict(basic_model, dtest)
prediction <- as.numeric(pred > 0.5)
print(head(prediction))
# 3. Model Performance measuring
err <- mean(as.numeric(pred > 0.5) != dtest$customer_response)
print(paste("test-error=", err))

# 4. Measuring learning progress
watchlist <- list(train = dtrain, test=dtest)
mod2 <- xgb.train(data = dtrain, booster = "gbtree", lambda=2, max.depth = 5, eta =1, nthread = 2, nrounds =3, watchlist = watchlist, objective = "binary:logistic")
# add, * eval.metric = "error", eval.metric = "logloss" for further monitoring.
#used linear boosting in this case, but can use dart booster with "booster=dart"
#step 2 is repeated for prediction, step 3 for performance measure

# 5. Feature importance
importance_matrix <- xgb.importance(model = mod2)
print(importance_matrix)
xgb.plot.importance(importance_matrix = importance_matrix)

label = getinfo(dtest, "label")
pred <- predict(mod2, dtest)
err <- as.numeric(sum(as.integer(pred > 0.5) != label))/length(label)
print(paste("test-error=", err))

xgb.dump(mod2, with_stats = T)

