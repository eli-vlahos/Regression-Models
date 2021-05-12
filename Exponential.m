function Exponential(D)
    arguments
        %specifies the type of input
        D (:,2) {mustBeNumeric, mustBeFinite};
    end
    
    %copies an original matrix and deletes all instances of a y being 0
    %(this causes error)
    Original = D;
    
    rowsToDelete = any(D(:,2) == 0,2);
    D(rowsToDelete,:) = [];
    %takes size and log
    s = size(D);
    s = s(1,1);
    
    ln_D = log(D);

    %average and sum initializer
    average_y = 0;
    average_x = 0;
    sum_x = 0;
    sum_y = 0;
    sum_xy = 0;
    sum_xx = 0;

    for i = 1:s
        %takes sum of each element
        sum_x = sum_x + D(i,1);
        sum_y = sum_y + ln_D(i,2);
        sum_xx = sum_xx + D(i,1)*D(i,1);
        sum_xy = sum_xy + D(i,1)*ln_D(i,2);
        
    end
    
    %initialize coefficients
    b = (s*sum_xy-sum_x*sum_y)/(s*sum_xx-sum_x^2);
    a = exp((sum_y-b*sum_x)/s);
    

    %takes original or old size, and initializes the new_Y, E and Standard
    %vectors
    old_s = size(Original);
    old_s = old_s(1,1);
    
    %compares sizes to output warning
    if s ~= old_s
        disp('Warning, one of the datapoints was invalid')
    end
    
    new_Y = zeros(old_s,1);
    E = zeros(old_s,1);
    Standard = zeros(old_s,1);
    
    %Takes floating point preference, initializes symbolic equation,
    %function and string that represents it
    sympref('FloatingPointOutput',true);
    syms x y
    f(x,y) = a*exp(x*b);
    str = append('Exponential, y = ',num2str(a),'*e^{x*(',num2str(b), ')}');
    
    %initializes new_Y, error and standard deviation vectors    
    for i = 1:old_s
        new_Y(i,1) = f(Original(i,1),Original(i,2));
        E(i,1) = (Original(i,2)-new_Y(i,1))^2;
        
        Standard(i,1) = (Original(i,2)-average_y)^2;
    end
    
    %initializes r_2 and calls display function
    r_2 = (sum(Standard)-sum(E))/sum(Standard);
    Display(Original, new_Y, str, r_2);
    
     
end