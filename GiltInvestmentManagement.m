function varargout = GiltInvestmentManagement(varargin)
% GILTINVESTMENTMANAGEMENT MATLAB code for GiltInvestmentManagement.fig
%      GILTINVESTMENTMANAGEMENT, by itself, creates a new GILTINVESTMENTMANAGEMENT or raises the existing
%      singleton*.
%
%      H = GILTINVESTMENTMANAGEMENT returns the handle to a new GILTINVESTMENTMANAGEMENT or the handle to
%      the existing singleton*.
%
%      GILTINVESTMENTMANAGEMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GILTINVESTMENTMANAGEMENT.M with the given input arguments.
%
%      GILTINVESTMENTMANAGEMENT('Property','Value',...) creates a new GILTINVESTMENTMANAGEMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GiltInvestmentManagement_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GiltInvestmentManagement_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GiltInvestmentManagement

% Last Modified by GUIDE v2.5 06-Aug-2014 14:03:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GiltInvestmentManagement_OpeningFcn, ...
                   'gui_OutputFcn',  @GiltInvestmentManagement_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before GiltInvestmentManagement is made visible.
function GiltInvestmentManagement_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GiltInvestmentManagement (see VARARGIN)

% Choose default command line output for GiltInvestmentManagement
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes GiltInvestmentManagement wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = GiltInvestmentManagement_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%/----------------------------------------------------------------------------------


%/ Download data: Push button call back function
function pushbutton1_Callback(hObject, eventdata, handles)
format long
%/ get data from downloader
DMOBondData= DMODailyPriceDownload();
DMOGilt = DMOGiltInIssue;
DMORPIVec = DMORPI;


%/ format data(convert data from table to cell
CombinedTable= CombineDMOTable(DMOBondData,DMOGilt);
CellCombinedTable = table2cell(CombinedTable);
%/ load data into uitable
set(handles.uitable1,'Data',CellCombinedTable);


%/ format uitable: set column witdth
set(handles.uitable1,'ColumnWidth','auto');
set(handles.uitable1,'ColumnName',{'ISIN', 'Bond Name','InssueDate','DivDate','exDivDate','MaturityBucket','MaturityDate','InstruType','COB','Clean Price','Dirty Price','AI','Yield','Modified Duration'})

%/ load current portfolio 
listing = dir('H:\Project\Matlab\Gilt Inv\Portfolio\MyPortfolio.csv');
if size(listing,1) ~= 0 
    MyPortfolio = readtable('H:\Project\Matlab\Gilt Inv\Portfolio\MyPortfolio.csv','FileType','spreadsheet','ReadVariableNames',false);
    %load current price and calculate market value & P&L
    for i = 1:size(MyPortfolio,1)
        index(i) = find(strcmp(MyPortfolio.Var1(i),CellCombinedTable(:,1)));
    end 
    MyPortfolio.CurrentPrice = CellCombinedTable(index, 11);
    
    MyPortfolio.MarketValue = round((cell2mat(MyPortfolio.CurrentPrice) .* MyPortfolio.Var3)/100);
    MyPortfolio.PNL = round(((cell2mat(MyPortfolio.CurrentPrice)-MyPortfolio.Var4) .* MyPortfolio.Var3)/100);
  
    % export result 
    CellMyPortfolio = table2cell(MyPortfolio);
    set(handles.uitable2,'Data',CellMyPortfolio);
    set(handles.uitable2,'ColumnName',{'ISIN','Bond Name','Notional','BookPrice','Current Price','MarketValue','P&L'});

    %/ calculate total portfolio value
   TotalVal = sum(MyPortfolio.MarketValue);
   set(handles.text15,'string',{TotalVal});
     

   %/ calculation p&l
   TotalPNL = sum(MyPortfolio.PNL);
   set(handles.text21,'string',{TotalPNL});
   
   %/ Nominal Curve
   ValDate = CellCombinedTable(1,9);
   NCurve = NominalCurve(CellCombinedTable(find(strcmp(CellCombinedTable(:,8),'Conventional ')),:), ValDate);
   
   %change y axes to %
   plot(handles.axes2,NCurve(:,1),NCurve(:,2));
   a=[cellstr(num2str(get(handles.axes2,'ytick')'*100))];
   pct = char(ones(size(a,1),1)*'%'); 
   new_yticks = [char(a),pct];
   set(handles.axes2,'yticklabel',new_yticks) 
   
   %/ project nominal Cash flow
   for i = 1:size(CellMyPortfolio,1)
       CouponRate = CouponRateFinder(CellMyPortfolio{i,2});
       MaturityDate = CellCombinedTable(find(strcmp(CellCombinedTable(:,1),CellMyPortfolio(i,1))),7);
       bond = BondClass('','',MaturityDate,CouponRate,2,1,0,cell2mat(CellMyPortfolio(i,3)),0,0);
       Cashflow = bond.CashFlowProject(ValDate,'');
       if i == 1
           Cashflows = [Cashflow];
       else
           Cashflows = [Cashflows;Cashflow];
       end    
   end
   IntCashFlow = CashFlowAggregator(Cashflows(:,1:2), 12);
   PrincipalCashFlow = CashFlowAggregator(Cashflows(:,[1 3]), 12);
   
   PrincipalCashFlow(find(IntCashFlow(:,2) ==0),:) = [];
   IntCashFlow(find(IntCashFlow(:,2) ==0),:) = [];
   
   
   bar(handles.axes1,IntCashFlow(:,2));
   set(handles.axes1,'XTickLabel','String') 
   set(handles.axes1,'XTickLabel',datestr(IntCashFlow(:,1)));
   
   bar(handles.axes5,PrincipalCashFlow(:,2));
   set(handles.axes5,'XTickLabel','String') 
   set(handles.axes5,'XTickLabel',datestr(IntCashFlow(:,1)));   
   
   
end



%/ bond selection function:  
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
%/ select bond function
 selected_cells = eventdata.Indices(1);
%/ extract data 
 data= get(handles.uitable1,'Data');
%/ set bond ISIN
set(handles.text3,'string',data(selected_cells(1),1));
%/ set bond name 
set(handles.text7,'string',data(selected_cells(1),2));
%/ set bond Dirty price 
set(handles.text8,'string',data(selected_cells(1),11));
%/ set bond maturity
set(handles.text13,'string',data(selected_cells(1),7));
%/ set notional to zero
set(handles.edit2,'string','0');
%/ set total cost to zero initially
set(handles.edit3,'string','0');


%/ bond filter: 
function popupmenu1_Callback(hObject, eventdata, handles)

%/ enter notioanl 
function edit2_Callback(hObject, eventdata, handles)
%/ get notional and dirty price from selection
%notional = str2num(get(handles.edit2,'string'));
%dirtyprice = str2num(get(handles.text8,'string'));
%/ calculate dirty price
%set(handles.text11,'string',num2str(notional*dirtyprice));
%xxx = 1;

% add bonds into portfolio
function pushbutton2_Callback(hObject, eventdata, handles)
% Get Original Data
OriginalData = get(handles.uitable2,'data');
format long

%/ Add bond to portfolio
   i = 1;
   while strcmp(OriginalData(i,1),'') ~= 1  
         i = i + 1;
         if i > size(OriginalData,1) 
            OriginalData(i,:) = {''} ;
         end
   end
   
   OriginalData(i,1) =  get(handles.text3,'string');
   OriginalData(i,2) =  get(handles.text7,'string');    
   OriginalData(i,3) =  {str2double(get(handles.edit2,'string'))}; 
   OriginalData(i,5) =  {str2double(get(handles.text8,'string'))}; 
   OriginalData(i,4) =  {str2double(get(handles.edit3,'string'))};
   OriginalData(i,6) =  {cell2mat(OriginalData(i,3))*cell2mat(OriginalData(i,4))};
   OriginalData(i,7) =  {(sprintf('%.4f',(cell2mat(OriginalData(i,4)) - cell2mat(OriginalData(i,5)))*cell2mat(OriginalData(i,3))))};

set(handles.uitable2,'data',OriginalData)
set(handles.uitable2,'ColumnName',{'ISIN','Bond Name','Notional','BookPrice','Current Price','MarketValue','P&L'});

%/ calculate total portfolio value
   TotalVal = sum(cell2mat(OriginalData(:,6)));
   set(handles.text15,'string',{TotalVal});
%/ calculate total risk
   

%/ calculation p&l
   TotalPNL = sum(str2double(OriginalData(find(~isnan(str2double(OriginalData(:,7)))),7)));
   set(handles.text21,'string',{TotalPNL});





function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

PortfolioData = get(handles.uitable2,'data');
%/ delete unwanted Data

if sum(strcmp(PortfolioData(:,1),'')) ~= 4 || size(PortfolioData,2) > 4
   index = [5 6 7];
   PortfolioData(:,index) = [];
   cell2csv('H:\Project\Matlab\Gilt Inv\Portfolio\MyPortfolio.csv', PortfolioData, ',', 2003, '.');
end

delete(hObject);
