%% %Part 2(a)
clc
clearvars

data= readtable("marijuana.xlsx");
data= convertvars(data, ["q85","educ","income","maritalStatus","sex","parent","pastUse","race","party"],'categorical');
data.y= zeros(size(data.q85));
data.y(data.q85=="Yes, legal")=1;
data.y(data.q85=="No, illegal")=0;

tabulate(data.y)
%% %Part 2(b)

data= renamevars(data, ["age", "hh1"], ["x2", "x3"]);

ageStats=[mean(data.x2) std(data.x2)]
hh1Stats=[mean(data.x3) std(data.x3)]
x2=data.x2;
x3=data.x3;

%% %Part 2(c)
data.x4= zeros(size(data.pastUse));
data.x4(data.pastUse=="Yes")=1;
data.x4(data.pastUse=="No")=0;
x4=data.x4;
tabulate(data.pastUse)
fprintf('\n')

%% %Part 2(d)

data.x5= zeros(size(data.sex));
data.x5(data.sex=="Male")=1;
data.x5(data.sex=="Female")=0;
tabulate(data.sex)
fprintf('\n')

data.x6= zeros(size(data.parent));
data.x6(data.parent=="Yes")=1;
data.x6(data.parent=="No")=0;
tabulate(data.parent)
fprintf('\n')
x5=data.x5;
x6=data.x6;
%% &Part 2(e)

data.maritalStatus= renamecats(data.maritalStatus, "Never been married", "single");
data.maritalStatus= mergecats(data.maritalStatus, ["Divorced", "Separated", "Widowed"],"post-married");
data.maritalStatus= mergecats(data.maritalStatus, ["Married","Living with a partner"], "couple");

data.x7= zeros(size(data.maritalStatus));
data.x7(data.maritalStatus=="single")=1;
data.x7(data.maritalStatus~= "single")=0;

data.x8= zeros(size(data.maritalStatus));
data.x8(data.maritalStatus=="post-married")=1;
data.x8(data.maritalStatus~= "post-married")=0;

x7=data.x7;
x8=data.x8;
tabulate(data.maritalStatus)
fprintf('\n')

%% %Part 2(f)

data.income= mergecats(data.income, ["Less than 10000","10 to under 20000",...
    "20 to under 30000","30 to under 40000","40 to under 50000"], "poor");
data.income= mergecats(data.income, ["50 to under 75000","75 to under 100000"], "middle");
data.income= mergecats(data.income, ["100 to under 150000","150000 or more"],"rich");

data.x9= zeros(size(data.income));
data.x9(data.income=="poor")=1;
data.x9(data.income~="poor")=0;
x9=data.x9;

data.x10= zeros(size(data.income));
data.x10(data.income=="middle")=1;
data.x10(data.income~="middle")=0;
x10=data.x10;
tabulate(data.income)
fprintf('\n')

%% %Part 2(g)

data.educ= mergecats(data.educ, ["Less than HS","HS","HS Incomplete"],"HSandBelow");
data.educ= mergecats(data.educ, ["Some college","Associate Degree"], "lessThanBachelors");
data.educ= mergecats(data.educ,["Bachelors","Postgraduate Degree","Some Postgraduate"],"BachelorsandAbove");

data.x11= zeros(size(data.educ));
data.x11(data.educ=="HSandBelow")=1;
data.x11(data.educ~="HSandBelow")=0;

data.x12= zeros(size(data.educ));
data.x12(data.educ=="lessThanBachelors")=1;
data.x12(data.educ~="lessThanBachelors")=0;

tabulate(data.educ)
fprintf('\n')
x11=data.x11;
x12=data.x12;
%% %Part 2(h)

data.race= renamecats(data.race,["White","Black"],["white", "black"]);
data.race= mergecats(data.race, ["Asian","Hispanic","Native American","Other Race","Pacific Islander"],...
    "allOther");
data.x13= zeros(size(data.race));
data.x13(data.race=="white")=1;
data.x13(data.race~="white")=0;

data.x14= zeros(size(data.race));
data.x14(data.race=="black")=1;
data.x14(data.race~="black")=0;

tabulate(data.race)
fprintf('\n')
x13=data.x13;
x14=data.x14;
%% %Part 2(i)
data.party= renamecats(data.party, ["Democrat","Republican"],...
    ["democrat","republican"]);
data.party= mergecats(data.party,["(VOL) No preference","(VOL) Other party","Independent"],...
    "independentOthers");
data.x15 = zeros(size(data.party));
data.x15(data.party == "democrat") = 1;
data.x15(data.party ~= "democrat") = 0;

data.x16=zeros(size(data.party));
data.x16(data.party=="republican")=1;
data.x16(data.party~="republican")=0;

tabulate(data.party)
fprintf('\n')
x15=data.x15;
x16=data.x16;
%% %Part 3(b)
n= size(data,1);
y= data.y;

mdl= fitglm(data,'y ~ x2+x3+x4+x5+x6+x7+x8+x9+x10+x11+x12+x13+x14+x15+x16')
beta_estimates= mdl.Coefficients.Estimate;

%% Part 3(c)
X = [ones(size(y)), x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16];

p_current= normcdf(X* beta_estimates);
X_new=X;
X_new(:,2)= X_new(:,2)+5;
p_new= normcdf(X_new*beta_estimates);
delta_p= mean(p_new- p_current);

fprintf('\n Change in probability (Age +5 years): %.4f\n', delta_p);

%% %Part 3(d)
X_1 = X;
X_0 = X;
X_1(:,6) = 1;
X_0(:,6) = 0;

p_1 = normcdf(X_1*beta_estimates);
p_0 = normcdf(X_0*beta_estimates);

delta_parents = mean(p_1 - p_0);
fprintf('\n Change in Probability if one is a parent is: %.4f\n', delta_parents);

%% %Part 4(b)
X_logit= [x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16];
mdl_logit= fitglm(X_logit, y, 'Distribution','binomial','Link','logit')

%% %Part 4(c)
p_age = predict(mdl_logit, X_logit);

X_fitglm_new = X_logit;
X_fitglm_new(:,1) = X_fitglm_new(:, 1) + 5;

p_age_new = predict(mdl_logit, X_fitglm_new);
age_covariate_effect = mean(p_age_new - p_age)

X_parents_0 = X_logit;
X_parents_0(:, 5) = 0;
X_parents_1 = X_logit;
X_parents_1(:,5) = 1;
p_par = predict(mdl_logit, X_parents_0);
p_par_new = predict(mdl_logit,X_parents_1);
parents_covariate_effect = mean(p_par_new - p_par)