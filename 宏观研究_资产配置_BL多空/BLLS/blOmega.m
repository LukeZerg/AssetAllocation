function omega = blOmega(conf, P, Sigma)
%����blģ���еĲ���Omega
    alpha = 1/conf-1;
    omega = alpha * P *Sigma * P';
end