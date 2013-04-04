% Victory Boogie-Woogie according to Jesse Dorrestijn & Keith Myerscough
%% initial stuff
close all
clear all
clc

%% the figure
figure('Color','w');
% R, B, Y, K, W, D(ark grey), L(ight grey)
colormap([[.8 0 0];[0 0 .8];[.95 .85 0];[0 0 0];[1 1 1];[.7 .7 .7];[.8 .8 .8]]);

%% parameters, feel free to play with these, default values in []
N = 72; % size of square (before trimming) [72]
M = 12; % multiplication factor for final image [12]
Nmin = 6;   %[6]
Nmax = 10; %[10]
ribbonfrac = 6; % reciprocol of how often to place a ribbon [6]
littlefrac = 2; % reciprocol of how often to place a little rectangle [2]

%% colours and their frequencies
Nc = 7; % number of colours
% R, B, Y, K, W, D(ark grey), L(ight grey)
pblock = [1 1 1 0 8 1 0]; % frequency of block colours in the centre [1 1 1 0 8 1 0]
pblock2 = [0 0 1 1 34 13 34]; % frequentcy of block colours at the edge [0 0 1 1 34 13 34]
pribbon = [3 3 3 3 0 0 1]; % frequency of ribbon colours [ 3 3 3 3 0 0 1];
qblock = cumsum(pblock);
qblock = qblock/qblock(end);
qblock2 = cumsum(pblock2);
qblock2 = qblock2/qblock2(end);
qribbon = cumsum(pribbon);
qribbon = qribbon/qribbon(end);

%% initialization
counter = 1;
% entries in A identify blocks, each block has a unique number
% an entry of '1' indicates this is part of a ribbon
A = uint32(zeros(N,N)); 
% matrix C contains the final colour for each pixel
C = int8(zeros(N,N));

%% main part!
A = divide(A,Nmin,Nmax,ribbonfrac,littlefrac,counter);

%% colour in blocks and ribbons
I = max(max(A));
for i=2:I
    C = colourblock(C,i,A,qblock,qblock2);
end
nribbon = sum(sum(A==1));
% the ribbons are coloured according to the colour frequency specified at the top
% no effort is made to avoid neighbours having the same colour
C(A==1) = sum(bsxfun(@gt,rand(nribbon,1), qribbon),2)+1;

%% increase resolution and make diagonal edges
N2 = N*M;
B = kron(C,int8(ones(M,M)));
% B is scaled up for beauty,
% and B is trimmed to give the vital diamond shape
% setting M=1 at the top will give a more pixely version, if you like that
for i=1:N2;
    for j=1:abs(N2/2-i)
        B(i,j)      = 5;
        B(i,N2-j+1) = 5;
    end
    B(i,j) = 7;
    B(i,N2-j+1) = 7;
end

%% show the picture
fig = figure(1);
image(double(B));
shading flat
axis image
axis off
drawnow;
pause(1)