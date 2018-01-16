function [M,S]=Log2Lin(Mu,Sigma)

M=exp(Mu+(1/2)*diag(Sigma))-1;
S=exp(Mu+(1/2)*diag(Sigma))*exp(Mu+(1/2)*diag(Sigma))'.*(exp(Sigma)-1);