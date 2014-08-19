function [CouponRate] = CouponRateFinder(BondName)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

PercentSignPosition = strfind(BondName,'%');

if PercentSignPosition == 2 
   CouponRate = str2double(BondName(1))/100; 
elseif PercentSignPosition == 3
   frac = BondName(2);
   DecimalNumber = fractionconvert(frac)/100;
   CouponRate = str2double(BondName(1))/100 + DecimalNumber;  
elseif PercentSignPosition > 3 
   CouponRate = str2double(BondName(1))/100 + str2double(BondName(3))/str2double(BondName(5))/100;
end    
    
end

