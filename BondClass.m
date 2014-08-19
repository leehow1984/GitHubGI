classdef BondClass
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name; 
        ISIN;
        Notional;
        Maturity;
        CouponRate;
        PayFreq;
        BondType; %/ index linked or not
        InitialIndex; %/ if it is a linker
        CurrentPrice;
        Yield;
    end
    
    %/ methods
    methods
        %/ construction method        
        function obj = BondClass(BondName,ISIN,MaturityDate,Coupon,Freq,Type,Index,Notional, Price, Yield)
           obj.Name = BondName;
           obj.ISIN = ISIN;
           obj.Maturity = datenum(MaturityDate);
           obj.CouponRate = Coupon;
           obj.PayFreq = Freq;
           obj.BondType = Type;
           obj.InitialIndex = Index;
           obj.Notional = Notional;
           obj.CurrentPrice = Price;
           obj.Yield = Yield;
        end
        
        
        
        %/ cashflow projection method
        function CashFlows = CashFlowProject(obj,ValDate,inflationcurve)
            
            %/ generate cashflow dates
            if isempty(ValDate)
               CFlowDates = transpose(cfdates(now(), obj.Maturity, obj.PayFreq, 3));  
            else
               CFlowDates = transpose(cfdates(ValDate,obj.Maturity, obj.PayFreq, 3));  
            end
            
            if obj.BondType == 1 %/ if it is a nominal bond
               for i = 1:size(CFlowDates,1)
                   Cashflow(i,1) = (obj.Notional * obj.CouponRate)/obj.PayFreq;
                   if i == size(CFlowDates,1)
                      Cashflow(i,2) = obj.Notional;
                   else    
                      Cashflow(i,2) = 0;
                   end    
               end    
            elseif obj.BondType == 2 %/ if it is a inflation linked bond
               if isempty(inflationcurve)
                  error('Not be able to project inflation linked bond with out inflation curve')
               end
               
               %/ development needed for inflation linked bond cash flow
               
               
               
               
               
            end
            CashFlows = [CFlowDates Cashflow];
        end
        
      
        
    end
    
end

