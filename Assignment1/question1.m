%% %Part1(a)
clc
clearvars

iggData= readtable("igg.xlsx");
age= iggData.age;
igg= iggData.IgG;
agesqr= age.^2;
iggData.agesqr= agesqr;

%Calculating the data for the summary
meanM1= [mean(age), mean(igg)];
medianM1= [median(age), median(igg)];
stdM1= [std(age), std(igg)];
maxM1= [max(age), max(igg)];
minM1= [min(age), min(igg)];

rowlabels= ['Age'; 'IgG'];

fprintf('                       Summary                \n')
fprintf('___________________________________________________\n')
fprintf('          mean   median     std      max      min  \n')
fprintf('        ________ ________ ________ ________ _______\n')
for i=1:length(meanM1)
    fprintf('%-6s  %6.3f  %6.3f   %6.3f   %6.3f   %6.3f\n',...
        rowlabels(i,:), meanM1(i), medianM1(i), stdM1(i), maxM1(i), minM1(i))
end

skewAge= skewness(age)
skewIgg= skewness(igg)
figure
histogram(age)
xlabel('Age')
ylabel('Frequency')

figure
histogram(igg)
xlabel('IgG')
ylabel('Frequency')

%% %Part 1(b)
%Estimating model 1 using OLS
mdl1= fitlm(iggData, 'IgG~ age')

%% %Part 1(c)
%Estimating model 2 using OLS
X2= [age agesqr];
mdl2= fitlm(iggData, 'IgG~ age+ agesqr')

%% %Part 1(d)
x= [ones(size(age)), age, agesqr];
[b2, b2int, r2, r2int, stats2]=regress(igg, x);
beta_curr= [b2(1); b2(2); b2(3)];
maxiter=5;
tolerance= 1e-9;

my_hess= -(x' * x);

for i=1:maxiter
    fprintf('--- Iteration %d ---\n', i);
    fprintf('Current Beta: [%.4f, %.4f, %.4f]\n', beta_curr);
    % gradient calculation
    gradient = x' * (igg - x*beta_curr);

    %calculate the update step = -inv(H) * g(beta)
    step = - my_hess \ gradient;
    beta_new = beta_curr + step;
    change = norm(beta_new - beta_curr);
    if change < tolerance
        beta_curr = beta_new;
        fprintf("Convergance achieved)");
        break;
    end
    beta_curr = beta_new;
end

resids= igg- x*beta_curr;

n= size(x,1);
k= size(x,2);

est_sigma= (resids'*resids)/(n-k);

cov_beta= est_sigma*inv(x'*x);

se= sqrt(diag(cov_beta));

res= table(beta_curr, se, 'RowNames', {'Intercept', 'Age', 'Agesqr'});
res.Properties.VariableNames= {'ML Estimates', 'SE'};
disp(res);