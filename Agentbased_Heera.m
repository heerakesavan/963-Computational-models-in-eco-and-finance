t0=0;   
dt = 1;
T=10;%Number of Rounds

%Create a new random array of values between [1,40]
VC = randi([1 200],1,40)

%Initialize array for Buyers valuations and Sellers costs

Buyers =[];
Sellers =[];
probSwitch =0.5

%randomvalue = rand();
% for i=1:length(VC)
%     if randomvalue<probSwitch
%         isBuyer(i) = 0;
%         isSeller(i) =1;
%     else
%         isBuyer(i) = 1;
%         isSeller(i) = 0;
%     end
% end

Buyer = VC(1:20);
Seller = VC(21:end);

%Sorting the arrays (Buyers in ascending and Sellers in Descending)
Buyers = sort(Buyer)
Sellers = sort(Seller,'Descend')

%Running 10 rounds to check if there was a trade and to calculate price at
%which the items were purchased
for t=t0:dt:T
    for i=1:length(Sellers)
        if Sellers(i)<=Buyers(i)
            price =((Sellers(i)+Buyers(i))/2)
        else
            disp("No trade")
        end
    end
end



