function [DMOGiltS]=DMOGiltInIssue()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%/ download data
xDoc = xmlread('http://www.dmo.gov.uk/xmlData.aspx?rptCode=D1A&page=D1A');
XmlObj = xmlwrite(xDoc);
%/ entry parent node
dataNode = xDoc.getDocumentElement;
%/ get child nodes
NumberOfChilds = dataNode.getLength;

%/ for each child node

for i = 1:NumberOfChilds
    tag1 = xDoc.getElementsByTagName('View_GILTS_IN_ISSUE').item(i-1);
    bond(i).IsinCode = char(tag1.getAttributes.getNamedItem('ISIN_CODE').getNodeValue);
    bond(i).InstrName = char(tag1.getAttributes.getNamedItem('INSTRUMENT_NAME').getNodeValue);
    bond(i).COB = DMODateConvert(char(tag1.getAttributes.getNamedItem('CLOSE_OF_BUSINESS_DATE').getNodeValue));
    bond(i).FirstIssueDate = DMODateConvert(char(tag1.getAttributes.getNamedItem('FIRST_ISSUE_DATE').getNodeValue));
    bond(i).DividendDate = char(tag1.getAttributes.getNamedItem('DIVIDEND_DATES').getNodeValue);
    bond(i).CurrentExDivDate = DMODateConvert(char(tag1.getAttributes.getNamedItem('CURRENT_EX_DIV_DATE').getNodeValue));
    try
         bond(i).MaturityBucket = char(tag1.getAttributes.getNamedItem('MATURITY_BRACKET').getNodeValue);
         bond(i).MaturityDate = DMODateConvert(char(tag1.getAttributes.getNamedItem('REDEMPTION_DATE').getNodeValue)); 
    end
    bond(i).InstrumentType = char(tag1.getAttributes.getNamedItem('INSTRUMENT_TYPE').getNodeValue); 
end

DMOGiltS = struct2table(bond);
end