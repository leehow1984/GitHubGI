function [RPI]=DMORPI()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%/ download data
xDoc = xmlread('http://www.dmo.gov.uk/xmlData.aspx?rptCode=D4O&page=D4O');
XmlObj = xmlwrite(xDoc);
%/ entry parent node
dataNode = xDoc.getDocumentElement;
%/ get child nodes
NumberOfChilds = dataNode.getLength;

%/ for each child node

for i = 1:NumberOfChilds
    tag1 = xDoc.getElementsByTagName('DIM_DATE').item(i-1);
    tag2 = tag1.getElementsByTagName('SILO_RPI_SERIES').item(0);
    
    RPI(i).Date = char(tag1.getAttributes.getNamedItem('RPI_DATE').getNodeValue);
    RPI(i).RPI74 = char(tag2.getAttributes.getNamedItem('RPI_SERIES_JAN_74').getNodeValue);
    RPI(i).RPI87 = char(tag2.getAttributes.getNamedItem('RPI_SERIES_JAN_87').getNodeValue);
end

RPI = struct2table(RPI);
end