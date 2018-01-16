function omega = blOmega(conf, P, Sigma)
%计算bl模型中的参数Omega
    alpha = 1/conf-1;
    omega = alpha * P *Sigma * P';
end