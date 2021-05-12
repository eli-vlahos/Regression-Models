function Polynomial(D, m)
    arguments
        %specifies the type of input
        D (:,2) {mustBeNumeric, mustBeFinite};
        m double;
    end
    
    %initializing zero matrices for the equation A*X=B
    %X is the matrix for the coefficients, A and B various sums
    A = zeros(m+1);
    B = zeros(m+1,1);
    
    %take size
    s = size(D);
    s = s(1,1);
    
    %initialize average of y
    average_y = 0;
    
    for i = 1:s
        %take sum of y
        average_y = average_y + D(i,2);
        
    end
    
    %divide to get mean
    average_y = average_y/s;
    
    %goes through each square in the A matrix to initialize all values
    for i = 1:m+1
        for j = 1:m+1
            
            
            if j == 1 & i == 1
                %for the 1,1 point, initialize to size
                A(1,1) = s;
            else
                
                for n = 1:s
                    %take sum and square values relative to the position
                    %in the matrix
                    A(i,j) = A(i,j)+D(n,1)^(i+j-2);
                    
                end
            end
        end
    end
    
    %Initialize the B vector
    for i  = 1:m+1
        for j = 1:s
            %take the sum for the value, using the relevant exponent
            B(i,1) = B(i,1) + (D(j,1))^(i-1)*D(j,2);
            
        end
    end
    
    %find solution for coefficients
    %initialize vectors for error, standard deviation and new Y values
    X = inv(A)*B;
    new_Y = zeros(s,1);
    E = zeros(s,1);
    Standard = zeros(s,1);
    
    %changing preference for symbolic equations
    sympref('FloatingPointOutput',true);
    syms x y
    
    %checking to see if the equation is linear and a data point indicates
    %no y intercept
    bool = 1;
    
    for i = 1:s
        if (D(i,2) == 0 & D(i,1) == 0 & m == 1)
            %if the equation is linear and possess a 0,0 point, initialize
            %differently
            bool = 0;
        end
        
    end
    
    %if the value fits the above conditions, will follow a different
    %procedure for what function it will be defined as
    if bool == 0
        
        %take sums necessary for linear function
        sum_xy = 0;
        sum_xx = 0;
        
        for i = 1:s
            sum_xy = sum_xy + D(i,1)*D(i,2);
            sum_xx = sum_xx + D(i,1)*D(i,1);
        end
        
        %initializes new function
        f(x,y) = x*(sum_xy/sum_xx);
        str = append('Polynomial, y = ',num2str(sum_xy/sum_xx));
    else
        %otherwise initialize function as expected
        f(x,y) = X(1,1)+x*X(2,1);
        str = append('Polynomial, y = ',num2str(X(1,1)),'+x*',num2str(X(2,1)));

        %use a loop to add all appropriate parts to the function and the
        %string that defines it
        for j = 3:m+1
            f(x,y) = f(x,y)+X(j,1)*x^(j-1);
            str = append(str,'+',num2str(X(j,1)),'*x^',num2str(j-1));
        end
    end
    
    %initializes new_Y, error and standard deviation vectors
    for i = 1:s
        new_Y(i,1) = f(D(i,1),D(i,2));
        E(i,1) = (D(i,2)-new_Y(i,1))^2;
        
        Standard(i,1) = (D(i,2)-average_y)^2;
    end
    
    %initializes r_2 and calls display function
    r_2 = (sum(Standard)-sum(E))/sum(Standard);
    
    Display(D, new_Y, str, r_2);

     
end