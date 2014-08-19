function [NCurve] = NominalCurve(NominalBonds, ValDate)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

MatArr = (datenum(NominalBonds(:,7)) - datenum(ValDate))/365;
YidArr = cell2mat(NominalBonds(:,13))/100;

TotArr = [MatArr YidArr];
TotArr = sortrows(TotArr,1);


NCurve(:,1) = [0.5:0.5:55];
NCurve(:,2) = spline(TotArr(:,1),TotArr(:,2),NCurve(:,1));


end

