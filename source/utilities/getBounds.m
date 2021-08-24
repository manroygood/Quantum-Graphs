function [leftCol,rightCol,topRow,bottomRow]=getBounds(nxC,k)
% This is a function to find the bounds of the submatrix
% Used to construct some matrices

leftCol=nxC(k)+1;
rightCol=nxC(k+1);
topRow = leftCol-2*(k-1);
bottomRow = rightCol-2*(k);