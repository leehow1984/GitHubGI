function [DecimalNumber] = fractionconvert(frac)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

   if strcmp(frac,'½')
      DecimalNumber = 0.5;
   elseif strcmp(frac,'¾') 
      DecimalNumber = 0.75;
   elseif strcmp(frac,'¼')
      DecimalNumber = 0.25;
   end  


end

