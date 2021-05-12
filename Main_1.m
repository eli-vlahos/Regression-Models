
%reads text file
A_1 = dlmread('test1.txt');

%user chooses model
I = input("1. Polynomial \n2. Exponential \n3. Saturation \nSelect the function to fit your data:");

 if I == 1
     %take degree then call function
     m = input("Degree of polynomial:");
     Polynomial(A_1, m);
 elseif I == 2
     %calls function
     Exponential(A_1);
 elseif I == 3
     %calls function
     Saturation(A_1);
 end