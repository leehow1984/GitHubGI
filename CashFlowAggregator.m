function [RearrangedCashFlow] = CashFlowAggregator(CashFlowVector, Frequency)
%/
%/ Input:  CashFlowVector: n X 2 (first column: Date (in datenum format)
%sorted
%/                              (second column: cash flow)
%/         Frequency: 1: Annual l 12: monthly 
%/ Output: RearrangedCashFlow: n/Frequency X 2;

Last_Date = CashFlowVector(size(CashFlowVector,1),1);
First_Date = CashFlowVector(1,1);

loopdate = First_Date;
i = 1;
while loopdate < Last_Date
    
    loopdate = datenum(year(First_Date),month(First_Date) + i, 1);
    if Frequency == 12
       RearrangedCashFlow(i,1) = datenum(year(First_Date),month(First_Date) + i, 1);
    elseif Frequency == 1
       RearrangedCashFlow(i,2) = datenum(year(First_Date)+i,month(First_Date), 1);
    end
    i = i + 1;
end    

for i = 1:size(RearrangedCashFlow,1)
    index = 0;
    if i == 1 
       index = find(CashFlowVector(:,1) < RearrangedCashFlow(i,1));
    else
       index = find((CashFlowVector(:,1) < RearrangedCashFlow(i,1)) == (CashFlowVector(:,1) > RearrangedCashFlow(i-1,1))); 
    end
    RearrangedCashFlow(i,2) = sum(CashFlowVector(index,2));
end



end