function Display(D, new_Y, symbolic, r_2)

%preference of floating point values
sympref('FloatingPointOutput',true);

%initializes data, labels and plots it
x = D(:,1);
y = new_Y;
z = D(:,2);
figure;
plot(x,y,x,z, 'o');
xlabel('x');
ylabel('y');

%finalizes legend
symbolic = append(symbolic,', R^2 = ', num2str(r_2));

legend(symbolic, 'Actual Data');

    
     
end