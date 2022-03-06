    %Load Data

TABLE=readtable("JETL.csv");
%Selecting Column with Closing prices
a_table=TABLE(:,5);
date=TABLE(:,1);
date(end,:) = [];
%Calculate Moving Average for 7 days and 14 days on Close price
closeprice = table2array(a_table);

%MA7 = movmean(a_array,7)
%MA14 = movmean(a_array,14)
g=1/7;
h=1/14;
[r,c] = size(closeprice);

%Movmean() gives wrong results hence finding 7 day and 14 day moving average
%using the formula in a for loop
for k = 8:r
    MA7(k) = g*(closeprice(k-7)+closeprice(k-6)+closeprice(k-5)+closeprice(k-4)+closeprice(k-3)+closeprice(k-2)+closeprice(k-1));
end
for k = 15:r
    MA14(k) = h*(closeprice(k-14)+closeprice(k-13)+closeprice(k-12)+closeprice(k-11)+closeprice(k-10)+closeprice(k-9)+closeprice(k-8)+closeprice(k-7)+closeprice(k-6)+closeprice(k-5)+closeprice(k-4)+closeprice(k-3)+closeprice(k-2)+closeprice(k-1));
end
MovAvg7 = MA7.';
MovAvg14 = MA14.';
BUY_signal =[];
SELL_signal=[];
Budget = [];
%Generating BUY and SELL Signals when 7 day moving average crosses 14 day
%moving average from below and above respectively.

[numRows,numCols] = size(MovAvg7);
for i = 1:numRows-1
    disp("numRows")
    BUY_signal(i,1) = (MovAvg7(i,1) < MovAvg14(i,1)) & (MovAvg7(i+1,1) > MovAvg14(i+1,1));
    SELL_signal(i,1) = (MovAvg7(i,1) > MovAvg14(i,1)) & (MovAvg7(i+1,1) < MovAvg14(i+1,1));
end


InitialBudget = 1000000; %Available Budget
Shares(1) = 0; %Number of Shares we have initially
Stocks(1) = round(InitialBudget/closeprice(1));%Number of stocks in budget initially
Budget(1)= InitialBudget;

for i = 2:r
    %Calculating Available Budget 
    if BUY_signal(i-1) == 1 
        Budget(i) = Budget(i-1)-Stocks(i-1)*closeprice(i-1);
    elseif SELL_signal(i-1) == 1
        Budget (i) = Budget(i-1)+Shares(i-1)*closeprice(i-1);
    else
        Budget(i) = Budget(i-1);
    end
    %Calculating Number of Shares
    if BUY_signal(i-1) == 1
        Shares(i) = Shares(i-1) + Stocks(i-1);
    elseif SELL_signal(i-1) == 1
        Shares(i) = 0;
    else
        Shares(i) =  Shares(i-1);
    end
    %Auxiliary values of Number of stocks 
    Stocks(i) = round(Budget(i)/closeprice(i));
end

% Calculating when or on which dates this Algorithm Buys or Sells
BUY = array2table(BUY_signal);
SELL = array2table(SELL_signal);
DATA = [date BUY SELL];
DATA.BUY = BUY;
DATA.SELL = SELL;
Buydates = DATA(DATA.BUY_signal==1,:)
Selldates = DATA(DATA.SELL_signal==1,:)

%Calculating how much your algorithm buys or sells in each deal
Budget1 = Budget.';
Budget1(end,:) = [];
DATA1 = [Budget1 BUY_signal SELL_signal];
BuyAmount = DATA1(BUY_signal==1,:)
SellAmount = DATA1(SELL_signal==1,:)

%Calculate the Updated Budget which is equal to Budget(126)+Shares(126)*closeprice(126) ,126 is last row
UpdatedBudget = Budget(126)+Shares(126)*closeprice(126)

%Profit is equal to UpdatedBudget - InitialBudget
Profit = UpdatedBudget - InitialBudget 

% Calculate Percent profit
PercentProfit = (Profit/InitialBudget)* 100 