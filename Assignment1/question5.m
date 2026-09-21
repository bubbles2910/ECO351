clc, clearvars
%Continuous
data_ed= readtable("EducationalAttainment.xlsx");
educLevel= data_ed.educLevel;
uniqueEducLevels = unique(educLevel);
educ_counts= histcounts(categorical(educLevel));
categories(categorical(uniqueEducLevels));
educ_percent= (educ_counts/sum(educ_counts))*100;
educLevelstats= [educ_counts, educ_percent]

famIncome= data_ed.famIncome;
famIncomestats= [mean(famIncome), std(famIncome)]

educMother= data_ed.educMother;
educMotherstats= [mean(educMother), std(educMother)]

educFather= data_ed.educFather;
educFatherstats= [mean(educFather),std(educFather)]

%Categorical
motherWorked= data_ed.motherWorked;
tabulate(motherWorked)
female= data_ed.female;
tabulate(female)
black= data_ed.black;
tabulate(black)
urban= data_ed.urban;
tabulate(urban)
south= data_ed.south;
tabulate(south)
age15= data_ed.age15;
tabulate(age15)
age16= data_ed.age16;
tabulate(age16)
age17= data_ed.age17;
tabulate(age17)

%% Part 5(c)
x_inc= sqrt(famIncome);
Y= categorical(educLevel);
X= [x_inc, educMother, educFather, motherWorked, female, black, urban, south, age15, age16, age17];

mdl_educ = fitmnr(X, Y, 'ModelType', 'ordinal', 'Link','probit');
fprintf('Ordinal Probit Model Results \n');
results_table = mdl_educ.Coefficients;
disp(results_table);

%hit-rate
predicts= predict(mdl_educ,X);
actual= sum(predicts==Y);
total_predicts= height(Y);
hit_rate= actual/total_predicts;
fprintf('Hit-rate (Accuracy: %.3f)\n', hit_rate);

mcf_r2= mdl_educ.Rsquared.Ordinary;
fprintf('The McFadden R-square comes out to be %f\n', mcf_r2);
%% %Part 5(d)
newinc= famIncome+10000;
x_new_inc= sqrt(newinc);
X_new= X;
X_new(:,1)= x_new_inc;

[~, new_prob]= predict(mdl_educ, X_new);
[~, curr_prob]= predict(mdl_educ, X);

avg_m_effect= mean(new_prob- curr_prob);

fprintf('Avg effect of a $10,000 increase in family income:\n');
cat_names= mdl_educ.ClassNames;
for i=1:length(cat_names)
    fprintf('Change in probability of "%s": %+.4f (or %+.2f%%)\n',...
        cat_names(i), avg_m_effect(i), avg_m_effect(i)*100);
end

