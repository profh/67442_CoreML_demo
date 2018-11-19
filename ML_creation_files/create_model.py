from sklearn.linear_model import LinearRegression
import pandas
import coremltools

data = pandas.read_csv("iphones.csv")

model = LinearRegression()
model.fit(data[["source","network","capacity","model","condition","color"]], data["price"])

coreml_model = coremltools.converters.sklearn.convert(model, ["source","network","capacity","model","condition","color"], "price")
coreml_model.author = "Prof. H"
coreml_model.license = "MIT"
coreml_model.short_description = "Predicts the resale value of an iPhone 8."
coreml_model.save("Phones.mlmodel")
