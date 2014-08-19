function [DMOGiltDailyData] = DMODailyPriceDownload()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%/ download data
xDoc = xmlread('http://www.dmo.gov.uk/xmlData.aspx?rptCode=D3B.2&page=Gilts/Daily_Prices');
XmlObj = xmlwrite(xDoc);
%/ entry parent node
dataNode = xDoc.getDocumentElement;
%/ get child nodes
NumberOfChilds = dataNode.getLength;

%/ for each child node
for i = 1:NumberOfChilds
    tag1 = xDoc.getElementsByTagName('SILO_DAILY_PRICES').item(i-1);
    bond(i).IsinCode = char(tag1.getAttributes.getNamedItem('ISIN_CODE').getNodeValue);
    bond(i).InstrName = char(tag1.getAttributes.getNamedItem('INSTRUMENT_NAME').getNodeValue);
    bond(i).COB = DMODateConvert(char(tag1.getAttributes.getNamedItem('CLOSE_OF_BUSINESS_DATE').getNodeValue));
    bond(i).CleanPrice = str2double(char(tag1.getAttributes.getNamedItem('CLEAN_PRICE').getNodeValue));
    bond(i).DirtyPrice = str2double(char(tag1.getAttributes.getNamedItem('DIRTY_PRICE').getNodeValue));
    bond(i).AI = str2double(char(tag1.getAttributes.getNamedItem('ACCRUED_INTEREST').getNodeValue));
    bond(i).Yield = str2double(char(tag1.getAttributes.getNamedItem('YIELD').getNodeValue));
    bond(i). MD = str2double(char(tag1.getAttributes.getNamedItem('MODIFIED_DURATION').getNodeValue));
end

%/ convert struct data to table 
DMOGiltDailyData = struct2table(bond);
end

