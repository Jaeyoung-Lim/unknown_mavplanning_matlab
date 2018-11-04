%% Learn representation of maps using autoencoders

data_dir = '/home/jalim/dev/unknown_mavplanning_matlab/data/fullmap';
test_dir = '/home/jalim/dev/unknown_mavplanning_matlab/data/test';

XTrain = read_dataset(data_dir);

hiddenSize = 25;
autoenc = trainAutoencoder(XTrain,hiddenSize,...
        'L2WeightRegularization',0.004,...
        'SparsityRegularization',4,...
        'SparsityProportion',0.15);
    
XTest = read_dataset(test_dir);

xReconstructed = predict(autoenc,XTest);

figure;
for i = 1:4
    subplot(1,4,i);
    imshow(XTest{i});
    subplot(2,4,i);
    imshow(xReconstructed{i});

end

function X = read_dataset(path)
    
    idx = 1;
    Files=dir(path);
    for k=1:length(Files)
        FileName = Files(k).name;
        if k > 2
            imgs = imread(strcat([path,'/', FileName]));
            X{idx} = imgs;
            idx = idx+1;
        end
    end
end