

XTrain = digitTrainCellArrayData;

hiddenSize = 25;
autoenc = trainAutoencoder(XTrain,hiddenSize,...
        'L2WeightRegularization',0.004,...
        'SparsityRegularization',4,...
        'SparsityProportion',0.15);
    
XTest = digitTestCellArrayData;
xReconstructed = predict(autoenc,XTest);
figure;
for i = 1:20
    subplot(4,5,i);
    imshow(XTest{i});
end