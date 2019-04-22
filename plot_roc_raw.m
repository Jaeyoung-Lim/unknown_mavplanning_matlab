clc; clear all;

%%
figure(2);
fprintf('-Bin source Benchmark\n');
fprintf('Resolution of Raw pointcloud: 1m\n');

% TSDF Map
A =[0, 1, 1, 0.508077;
0.05, 1, 1, 0.508077;
0.1, 0.999988, 1, 0.50808;
0.15, 0.997433, 1, 0.50872;
0.2, 0.980329, 0.999927, 0.513014;
0.25, 0.917235, 0.999316, 0.529375;
0.3, 0.759855, 0.996532, 0.574714;
0.35, 0.486863, 0.987846, 0.674157;
0.4, 0.239359, 0.963712, 0.79409;
0.45, 0.100539, 0.905307, 0.862201;
0.5, 0.0371007, 0.787633, 0.847156;
0.55, 0.0139041, 0.581209, 0.722837;
0.6, 0.00567899, 0.342259, 0.50583;
0.65, 0.00210934, 0.158866, 0.273211;
0.7, 0.000697553, 0.0594065, 0.112008;
0.75, 0.00018652, 0.0168198, 0.0330713;
0.8, 1.97135e-05, 0.00313315, 0.00624649;
0.85, 0, 0.000293641, 0.000587109;
0.9, 0, 0, 0;
0.95, 0, 0, 0;
1.0, 0, 0, 0];

Prob = A(:, 1);
fpr = A(:, 2);
tpr = A(:, 3);

plot(fpr, tpr, 'k-'); hold on;
x_order = fpr(end:-1:1); %fliplr
y_order = tpr(end:-1:1); %fliplr

fprintf('TSDF Map AOC: %f \n', trapz(x_order, y_order));
% Raw Map

A =[0, 1, 1, 0.508077;
0.05, 0.990633, 1, 0.510429;
0.1, 0.948478, 1, 0.521289;
0.15, 0.878406, 1, 0.540401;
0.2, 0.797494, 1, 0.56429;
0.25, 0.718462, 1, 0.589756;
0.3, 0.633415, 0.99988, 0.619806;
0.35, 0.530321, 0.99889, 0.660247;
0.4, 0.392336, 0.994817, 0.722311;
0.45, 0.231575, 0.976843, 0.805555;
0.5, 0.136693, 0.913382, 0.838705;
0.55, 0.0731991, 0.535316, 0.638399;
0.6, 0.0390311, 0.188996, 0.298908;
0.65, 0.0194951, 0.0587781, 0.107208;
0.7, 0.00834941, 0.0186873, 0.0361158;
0.75, 0.00278263, 0.00667446, 0.0131898;
0.8, 0.000714234, 0.00263983, 0.00525851;
0.85, 0.000100084, 0.000922032, 0.00184201;
0.9, 0, 0.000237849, 0.000475585;
0.95, 0, 0, 0;
1.0, 0.0, 0.0, 0];

Prob = A(:, 1);
fpr = A(:, 2);
tpr = A(:, 3);

plot(fpr, tpr, 'k-.'); hold on;
x_order = fpr(end:-1:1); %fliplr
y_order = tpr(end:-1:1); %fliplr

fprintf('Raw Map AOC: %f \n', trapz(x_order, y_order));

% 25% Sparse Raw Map

A =[0, 1, 1, 0.508077;
0.05, 0.967185, 1, 0.516414;
0.1, 0.910985, 1, 0.531344;
0.15, 0.840797, 1, 0.551249;
0.2, 0.773935, 0.999971, 0.571636;
0.25, 0.71103, 0.99985, 0.592207;
0.3, 0.65218, 0.999589, 0.612779;
0.35, 0.590142, 0.999104, 0.635995;
0.4, 0.520447, 0.997751, 0.663939;
0.45, 0.431697, 0.991126, 0.701169;
0.5, 0.194541, 0.932219, 0.80749;
0.55, 0.101059, 0.249695, 0.345506;
0.6, 0.0556329, 0.107784, 0.177347;
0.65, 0.0287725, 0.050192, 0.0907708;
0.7, 0.0139526, 0.0241901, 0.0460235;
0.75, 0.00604293, 0.0115988, 0.0226694;
0.8, 0.00242627, 0.00569663, 0.0112761;
0.85, 0.000812801, 0.00253412, 0.00504751;
0.9, 0.000113731, 0.000731166, 0.00146094;
0.95, 0, 2.93641e-05, 5.87265e-05;
1.0, 0.0, 0.0, 0];

Prob = A(:, 1);
fpr = A(:, 2);
tpr = A(:, 3);

plot(fpr, tpr, 'b--'); hold on;
x_order = fpr(end:-1:1); %fliplr
y_order = tpr(end:-1:1); %fliplr
fprintf('25 percent Raw Map AOC: %f \n', trapz(x_order, y_order));
% 10% Sparse Raw Map

A =[0, 1, 1, 0.508077;
0.05, 0.967326, 1, 0.516377;
0.1, 0.909118, 1, 0.531855;
0.15, 0.841489, 0.999991, 0.551042;
0.2, 0.774686, 0.99993, 0.571382;
0.25, 0.714264, 0.999683, 0.59104;
0.3, 0.652634, 0.99914, 0.612423;
0.35, 0.58898, 0.997472, 0.635742;
0.4, 0.518864, 0.992527, 0.662289;
0.45, 0.425297, 0.97993, 0.699081;
0.5, 0.201256, 0.918174, 0.795683;
0.55, 0.110705, 0.267337, 0.36085;
0.6, 0.0612527, 0.117289, 0.189803;
0.65, 0.0328487, 0.0539712, 0.0965859;
0.7, 0.0156722, 0.0244192, 0.0463025;
0.75, 0.00694217, 0.0112934, 0.0220416;
0.8, 0.00257943, 0.00493023, 0.00976356;
0.85, 0.000818867, 0.00181176, 0.00361126;
0.9, 0.000130412, 0.000449271, 0.000897911;
0.95, 0, 0, 0;
1.0, 0.0, 0.0, 0];

Prob = A(:, 1);
fpr = A(:, 2);
tpr = A(:, 3);

plot(fpr, tpr, 'g--'); hold on;
x_order = fpr(end:-1:1); %fliplr
y_order = tpr(end:-1:1); %fliplr
fprintf('10 percent Raw Map AOC: %f \n', trapz(x_order, y_order));

% 5% Sparse Raw Map

A =[0, 1, 1, 0.508077;
0.05, 0.968801, 1, 0.515996;
0.1, 0.908689, 1, 0.531972;
0.15, 0.836817, 1, 0.552422;
0.2, 0.767592, 0.999977, 0.573653;
0.25, 0.708324, 0.999871, 0.593135;
0.3, 0.65131, 0.999686, 0.613137;
0.35, 0.591793, 0.999087, 0.635341;
0.4, 0.523274, 0.996978, 0.662389;
0.45, 0.417695, 0.989229, 0.707083;
0.5, 0.183227, 0.920159, 0.808944;
0.55, 0.102627, 0.252696, 0.348204;
0.6, 0.0564305, 0.107382, 0.176519;
0.65, 0.0286558, 0.0487415, 0.0882813;
0.7, 0.0122512, 0.021424, 0.0409972;
0.75, 0.00439458, 0.0097665, 0.0191824;
0.8, 0.00150884, 0.00386725, 0.00768235;
0.85, 0.000359391, 0.00113052, 0.00225691;
0.9, 4.7009e-05, 0.000111584, 0.000223122;
0.95, 0, 0, 0;
1.0, 0.0, 0.0, 0];

Prob = A(:, 1);
fpr = A(:, 2);
tpr = A(:, 3);

plot(fpr, tpr, 'r--'); hold on;
x_order = fpr(end:-1:1); %fliplr
y_order = tpr(end:-1:1); %fliplr
fprintf('5 percent Raw Map AOC: %f \n', trapz(x_order, y_order));

title('ROC Curve'); hold on;
xlabel('False Positive Rate'); hold on;
ylabel('True Positive Rate'); hold on;
legend('TSDF map source', 'Full raw map source', '25% raw map source', '10% raw map source', '5% raw map source'); hold off;
%%
figure(3);
fprintf('---------------resolition 2m---------------\n');

% TSDF Map
A =[0, 1, 1, 0.508077;
0.05, 1, 1, 0.508077;
0.1, 0.999898, 1, 0.508103;
0.15, 0.996825, 1, 0.508872;
0.2, 0.978911, 0.999912, 0.51337;
0.25, 0.912161, 0.999263, 0.530735;
0.3, 0.752839, 0.996846, 0.577104;
0.35, 0.48987, 0.989047, 0.673363;
0.4, 0.235661, 0.965274, 0.797217;
0.45, 0.101869, 0.907171, 0.862154;
0.5, 0.0452105, 0.791509, 0.842454;
0.55, 0.0190508, 0.584563, 0.721036;
0.6, 0.00654183, 0.325448, 0.486427;
0.65, 0.00171052, 0.146298, 0.254517;
0.7, 0.000376072, 0.0506266, 0.0963074;
0.75, 2.72956e-05, 0.0145088, 0.0286011;
0.8, 0, 0.0032418, 0.00646264;
0.85, 0, 0.000422843, 0.000845328;
0.9, 0, 0, 0;
0.95, 0, 0, 0;
1.0, 0, 0, 0];

Prob = A(:, 1);
fpr = A(:, 2);
tpr = A(:, 3);

plot(fpr, tpr, 'k-'); hold on;
x_order = fpr(end:-1:1); %fliplr
y_order = tpr(end:-1:1); %fliplr

fprintf('TSDF Map AOC: %f \n', trapz(x_order, y_order));
% Raw Map

A =[0, 1, 1, 0.508077;
0.05, 0.993604, 1, 0.509681;
0.1, 0.968275, 1, 0.516132;
0.15, 0.922767, 1, 0.528143;
0.2, 0.859164, 1, 0.545897;
0.25, 0.78094, 0.999977, 0.569431;
0.3, 0.700032, 0.999885, 0.59598;
0.35, 0.599826, 0.999513, 0.632399;
0.4, 0.464358, 0.998212, 0.68904;
0.45, 0.302714, 0.99287, 0.769951;
0.5, 0.217599, 0.969828, 0.811169;
0.55, 0.160524, 0.758433, 0.733043;
0.6, 0.116161, 0.386311, 0.479518;
0.65, 0.0793618, 0.177714, 0.26696;
0.7, 0.0509517, 0.0809421, 0.137236;
0.75, 0.028398, 0.0352252, 0.0646206;
0.8, 0.0123452, 0.0138334, 0.0266607;
0.85, 0.00434303, 0.0041697, 0.0082358;
0.9, 0.000920467, 0.000625455, 0.00124791;
0.95, 0.000100084, 0, 0;
1.0, 0.0, 0.0, 0];

Prob = A(:, 1);
fpr = A(:, 2);
tpr = A(:, 3);

plot(fpr, tpr, 'k-.'); hold on;
x_order = fpr(end:-1:1); %fliplr
y_order = tpr(end:-1:1); %fliplr

fprintf('Raw Map AOC: %f \n', trapz(x_order, y_order));

% 25% Sparse Raw Map

A =[0, 1, 1, 0.508077;
0.05, 0.970812, 1, 0.515479;
0.1, 0.931367, 1, 0.52583;
0.15, 0.883263, 0.999997, 0.53903;
0.2, 0.827876, 0.999953, 0.555058;
0.25, 0.771486, 0.999838, 0.572358;
0.3, 0.718266, 0.999598, 0.589654;
0.35, 0.66488, 0.999072, 0.607976;
0.4, 0.604456, 0.99758, 0.629775;
0.45, 0.528122, 0.993928, 0.658975;
0.5, 0.309321, 0.980015, 0.76;
0.55, 0.205211, 0.443368, 0.481728;
0.6, 0.147993, 0.25323, 0.328912;
0.65, 0.106956, 0.158921, 0.232676;
0.7, 0.0752008, 0.0978059, 0.157317;
0.75, 0.0488439, 0.0555862, 0.0966576;
0.8, 0.0266571, 0.0275788, 0.0511097;
0.85, 0.0110926, 0.01159, 0.022438;
0.9, 0.00299948, 0.00380559, 0.0075387;
0.95, 0.00016529, 0.000769339, 0.001537;
1.0, 0.0, 0.0, 0];

Prob = A(:, 1);
fpr = A(:, 2);
tpr = A(:, 3);

plot(fpr, tpr, 'b--'); hold on;
x_order = fpr(end:-1:1); %fliplr
y_order = tpr(end:-1:1); %fliplr
fprintf('25 percent Raw Map AOC: %f \n', trapz(x_order, y_order));
% 10% Sparse Raw Map

A =[0, 1, 1, 0.508077;
0.05, 0.973361, 1, 0.514824;
0.1, 0.934541, 1, 0.524982;
0.15, 0.886758, 1, 0.53805;
0.2, 0.830966, 1, 0.554156;
0.25, 0.769726, 0.999977, 0.572974;
0.3, 0.714927, 0.999927, 0.590918;
0.35, 0.661346, 0.999683, 0.609504;
0.4, 0.59921, 0.998176, 0.632059;
0.45, 0.51739, 0.992641, 0.662972;
0.5, 0.30739, 0.97194, 0.757206;
0.55, 0.210878, 0.458564, 0.491255;
0.6, 0.151198, 0.264333, 0.339516;
0.65, 0.108676, 0.162084, 0.236184;
0.7, 0.0762471, 0.0985253, 0.158125;
0.75, 0.049916, 0.0545526, 0.0947744;
0.8, 0.027987, 0.0260195, 0.0481748;
0.85, 0.0125423, 0.0103391, 0.0199861;
0.9, 0.00375162, 0.00281602, 0.00557582;
0.95, 0.000303284, 0.000340623, 0.000680615;
0.95, 0, 0, 0;
1.0, 0.0, 0.0, 0];

Prob = A(:, 1);
fpr = A(:, 2);
tpr = A(:, 3);

plot(fpr, tpr, 'g--'); hold on;
x_order = fpr(end:-1:1); %fliplr
y_order = tpr(end:-1:1); %fliplr
fprintf('10 percent Raw Map AOC: %f \n', trapz(x_order, y_order));

% 5% Sparse Raw Map

A =[0, 1, 1, 0.508077;
0.05, 0.972964, 1, 0.514926;
0.1, 0.933778, 1, 0.525186;
0.15, 0.885412, 0.999994, 0.538425;
0.2, 0.827145, 0.999935, 0.555269;
0.25, 0.768277, 0.999794, 0.57336;
0.3, 0.716316, 0.999436, 0.590244;
0.35, 0.66418, 0.998623, 0.608036;
0.4, 0.603518, 0.997272, 0.630002;
0.45, 0.5253, 0.994665, 0.660498;
0.5, 0.323273, 0.977619, 0.750972;
0.55, 0.21922, 0.477219, 0.501882;
0.6, 0.157385, 0.273559, 0.346646;
0.65, 0.11466, 0.167182, 0.240686;
0.7, 0.0816577, 0.101888, 0.161725;
0.75, 0.0533431, 0.0571102, 0.0984316;
0.8, 0.028627, 0.0268212, 0.0495653;
0.85, 0.0107317, 0.00997498, 0.0193547;
0.9, 0.00237016, 0.00297165, 0.00589869;
0.95, 0.000236561, 0.000234913, 0.0004695;
1.0, 0.0, 0.0, 0];

Prob = A(:, 1);
fpr = A(:, 2);
tpr = A(:, 3);

plot(fpr, tpr, 'r--'); hold on;
x_order = fpr(end:-1:1); %fliplr
y_order = tpr(end:-1:1); %fliplr
fprintf('5 percent Raw Map AOC: %f \n', trapz(x_order, y_order));

title('ROC Curve'); hold on;
xlabel('False Positive Rate'); hold on;
ylabel('True Positive Rate'); hold on;
legend('TSDF map source', 'Full raw map source', '25% raw map source', '10% raw map source', '5% raw map source'); hold off;

%%
figure(4);
fprintf('---------------Resolition Benchmark---------------\n');
fprintf('Resolition of Anchorpoints: 1.1m\n');

% Resolution 1.1
A =[0, 1, 1, 0.508077;
0.05, 1, 1, 0.508077;
0.1, 0.999836, 1, 0.508118;
0.15, 0.996385, 1, 0.508982;
0.2, 0.97647, 1, 0.514027;
0.25, 0.905526, 0.999903, 0.532803;
0.3, 0.736299, 0.999034, 0.58341;
0.35, 0.476356, 0.994042, 0.681677;
0.4, 0.247825, 0.974726, 0.794198;
0.45, 0.116467, 0.921677, 0.85849;
0.5, 0.0528548, 0.813917, 0.849482;
0.55, 0.0211829, 0.614444, 0.742323;
0.6, 0.00784596, 0.351752, 0.514655;
0.65, 0.00282661, 0.162084, 0.277646;
0.7, 0.000915918, 0.0608953, 0.114608;
0.75, 0.000157708, 0.01741, 0.0342138;
0.8, 2.8812e-05, 0.0026134, 0.00521289;
0.85, 0, 9.39651e-05, 0.000187913;
0.9, 0, 0, 0;
0.95, 0, 0, 0;
1.0, 0, 0, 0];

Prob = A(:, 1);
fpr = A(:, 2);
tpr = A(:, 3);

plot(fpr, tpr, 'r-'); hold on;
x_order = fpr(end:-1:1); %fliplr
y_order = tpr(end:-1:1); %fliplr
fprintf('Resolution 1.1m AOC: %f \n', trapz(x_order, y_order));

% 0.7m
A =[0, 1, 1, 0.508077;
0.05, 0.998693, 1, 0.508404;
0.1, 0.905706, 1, 0.532791;
0.15, 0.698373, 1, 0.596599;
0.2, 0.479735, 1, 0.682836;
0.25, 0.318347, 0.999985, 0.764388;
0.3, 0.21986, 0.999824, 0.824406;
0.35, 0.155388, 0.998497, 0.868488;
0.4, 0.11107, 0.994292, 0.900068;
0.45, 0.0773131, 0.985139, 0.922912;
0.5, 0.0508486, 0.969505, 0.93764;
0.55, 0.0314809, 0.945982, 0.94271;
0.6, 0.0179438, 0.908992, 0.935303;
0.65, 0.00958984, 0.854351, 0.912319;
0.7, 0.00509669, 0.77915, 0.871036;
0.75, 0.00261582, 0.682739, 0.809026;
0.8, 0.00126773, 0.550401, 0.708888;
0.85, 0.000436729, 0.28472, 0.442949;
0.9, 0, 0.0283217, 0.0550833;
0.95, 0, 0, -nan;
1.0, 0, 0, 0];

Prob = A(:, 1);
fpr = A(:, 2);
tpr = A(:, 3);

plot(fpr, tpr, 'g-'); hold on;
x_order = fpr(end:-1:1); %fliplr
y_order = tpr(end:-1:1); %fliplr
fprintf('Resolution 0.7m AOC: %f \n', trapz(x_order, y_order));


% 2.2m
A =[0, 1, 1, 0.508077;
0.05, 1, 1, 0.508077;
0.1, 1, 1, 0.508077;
0.15, 0.999794, 1, 0.508129;
0.2, 0.99906, 1, 0.508312;
0.25, 0.997815, 1, 0.508624;
0.3, 0.994733, 1, 0.509397;
0.35, 0.988663, 1, 0.510927;
0.4, 0.975833, 1, 0.51419;
0.45, 0.943641, 0.999298, 0.522294;
0.5, 0.130159, 0.673504, 0.699546;
0.55, 0.000632347, 0.0378121, 0.0727831;
0.6, 0.000204717, 0.0150256, 0.0295948;
0.65, 4.54926e-05, 0.00606075, 0.0120474;
0.7, 0, 0.00202612, 0.00404405;
0.75, 0, 0.000484508, 0.000968546;
0.8, 0, 4.11097e-05, 8.22161e-05;
0.85, 0, 0, 0;
0.9, 0, 0, 0;
0.95, 0, 0, 0;
1.0, 0, 0, 0];

Prob = A(:, 1);
fpr = A(:, 2);
tpr = A(:, 3);

plot(fpr, tpr, 'b-'); hold on;
x_order = fpr(end:-1:1); %fliplr
y_order = tpr(end:-1:1); %fliplr
fprintf('Resolution 2.2m AOC: %f \n', trapz(x_order, y_order));


title('Resolution of ROC'); hold on;
xlabel('False Positive Rate'); hold on;
ylabel('True Positive Rate'); hold on;
legend('Resolution 1.1m', 'Resolution 0.7m', 'Resolution 2.2m'); hold off;
