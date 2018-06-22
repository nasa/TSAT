% Ex_PolySumAndProd.m ====================================================%

% Written By: Jonathan Kratz
% Date: January 2, 2018
% Description: This script illustrates the usage of the "PolySum.m"
% and "PolyProd" function. These are general-use tool that can be used to
% sum and multiply polynomials.

close all
clear all
clc

% Polynomials
p1 = [1 2 3]; % x^2 + 2*x + 3
p2 = [3 -5 -1 2]; % 3*x^3 - 5*x^2 - 1*x + 2

% Polynomial Sum
pSum = PolySum(p1,p2);
fprintf('Summation of p1 and p2 = %-2.0ix^3 + %-2.0ix^2 + %-2.0ix + %-2.0i\n',pSum(1),pSum(2),pSum(3),pSum(4));

% Polynomial Product
pProd = PolyProd(p1,p2);
fprintf('Product of p1 and p2 = %-2.0ix^5 + %-2.0ix^4 + %-2.0ix^3 + %-2.0ix^2 + %-2.0ix + %-2.0i\n',pProd(1),pProd(2),pProd(3),pProd(4),pProd(5),pProd(6));