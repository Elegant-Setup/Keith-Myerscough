function [A, counter] = divide(A,Nmin,Nmax,ribbonfrac,littlefrac,counter)
% recursive function that divides blocks, with or without ribbons
% and numbers blocks with a unique number

[N,M] = size(A);

dir = 1+(M > N);
if(dir > 1) % transpose such that the first dimension is the larger
    A = A';
end

[N,M] = size(A);
id = ceil(N*rand());

r = rand();
r0 = (N-Nmin)/(Nmax-Nmin);

if(r < r0/ribbonfrac) % divide with ribbon
    A(id,:) = 1;
    idm = id-1;
    idp = id+1;
    split = 1;
elseif(r < r0) % divide without ribbon
    idm = id;
    idp = id;
    split = 1;
else % number this rectangle
    A = counter*ones(N,M);
    if(rand() < 1/littlefrac && M > 6) % add a small rectangle
        counter = counter + 1;
        A(ceil(N/2):ceil(N/2+1),ceil(M/2):ceil(M/2+1)) = counter;
    end
    split = 0;
end

if(split) % dividing of the areas
    counter = counter + 1;
    [A(1:idm,:), counter] = divide(A(1:idm,:),Nmin,Nmax,ribbonfrac,littlefrac,counter);
    counter = counter + 1;
    [A(idp:end,:), counter] = divide(A(idp:end,:),Nmin,Nmax,ribbonfrac,littlefrac,counter);
end

if(dir > 1) % transpose matrix back
    A = A';
end