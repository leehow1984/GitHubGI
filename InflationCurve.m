classdef InflationCurve
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        CurveName;
        Dates;
        ZeroRates;
        Inflevel;
        HistoricalRPI;
        CurveDate;
        Lag;
    end
    
    methods
        %/obj construction
        function obj = InflationCurve(CurveName, CurveDate,Dates,ZeroRates,HistoricalRPI,Lag)
            obj.CurveDate = CurveDate;
            obj.Dates = Dates;
            obj.ZeroRates = ZeroRates;
            obj.HistoricalRPI = HistoricalRPI;
            obj.Lag = Lag;
            obj.CurveName = CurveName;
        end
        
        
        %/curve construction/projection 
        function InfCurve = InfCurveProjection(obj)
            LookBackDate = datenum(year(obj.CurveDate),month(obj.CurveDate) - obj.Lag, 1);
            StartingLevel= obj.HistoricalRPI(find(obj.HistoricalRPI(:,1) == LookBackDate),2);    
               
        
        end
    end
    
end

