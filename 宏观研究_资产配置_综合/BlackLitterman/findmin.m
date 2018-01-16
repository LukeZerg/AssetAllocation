function result = findmin(x,Mu_BL,Sigma_BL,delta)
%BL模型目标函数
result = -1*(x'*Mu_BL-delta/2*x'*Sigma_BL*x);
end