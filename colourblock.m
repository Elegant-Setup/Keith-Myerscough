function C = colourblock(C,i,A,q1,q2)

N = size(A,1);
N2 = N/2;

ids = find(A==i);
L = length(ids);
if L>0
    colours = [];
    [I,J] = ind2sub(size(C),ids);
    for l=1:L % search for colours in neighbouring blocks
        is = max(min([I(l)+1, I(l), I(l)-1, I(l)],N),1);
        js = max(min([J(l), J(l)-1, J(l), J(l)+1],N),1);
        colours = unique([colours; reshape(C(is,js),16,1)]);
    end
    a = min(((mean(I)-N2)^2 + (mean(J)-N2)^2)/N2^2,1)^2;
    q = (1-a)*q1 + a*q2;
    newcolour = 0;
    while(newcolour == 0) % pick a colour that no neighbour has
        newcolour = sum(rand() > q)+1;
        if find(colours==newcolour)
            newcolour = 0;
        end
    end
    C(ids) = newcolour; % colour in the block
end
