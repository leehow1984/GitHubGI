function [CombinedTable]= CombineDMOTable(PriceTable,GiltInfoTable)

CombinedTable = join(GiltInfoTable,PriceTable,'Keys','IsinCode');

%/ Delete unwanted data
CombinedTable.InstrName_PriceTable = [];
CombinedTable.COB_GiltInfoTable = [];
end