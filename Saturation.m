function Saturation(D)
    arguments
        %specifies the type of input
        D (:,2) {mustBeNumeric, mustBeFinite};
    end
    
    %copies an original matrix and deletes all instances of a y or x being 0
    %(this causes error)
    Original = D;
    
    rowsToDelete = any(D == 0,2);
    D(rowsToDelete,:) = [];

    %takes size and initializes averages and sums
    s = size(D);
    s = s(1,1);

    average_y = 0;
    average_x = 0;
    sum_x = 0;
    sum_y = 0;
    sum_xy = 0;
    sum_xx = 0;

    %takes sum
    for i = 1:s
        sum_x = sum_x + 1/D(i,1);
        sum_y = sum_y + 1/D(i,2);
        sum_xx = sum_xx + (1/D(i,1))*(1/D(i,1));
        sum_xy = sum_xy + (1/D(i,1))*(1/D(i,2));
    end
    
    % initializes coefficients
    a_0 = (s*sum_xy-sum_x*sum_y)/(s*sum_xx-sum_x^2);
    a = 1/((sum_y-a_0*sum_x)/s);
    b = a_0*a;
    

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
    
    sympref('FloatingPointOutput',true);
    syms x y
    f(x,y) = (a*x)/(b+x);
    str = append('Saturation, y = ',num2str(a),'*x/(',num2str(b), '+x)');
    
    
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