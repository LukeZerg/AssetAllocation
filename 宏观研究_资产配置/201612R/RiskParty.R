RiskParity = function(Sub) 
#Sub是N行M列的数据，N个日期，M个资产的收益
{
  m = ncol(Sub)
  Cov = matrix(cov(Sub, use = "na.or.complete"), m, m)
  TotalTRC = function(x)
  { x = matrix(c(x, 1-sum(x)))
    TRC = as.vector((Cov %*% x) * x)
    return(sum(outer(TRC, TRC, "-")^2))
  }
  sol = optim(par = rep(1/m,m-1), TotalTRC)
  w = c(sol$par, 1-sum(sol$par))
  return(w)
  


df = read.csv("D:/001Work/data.csv")#读取数据格式不能为
ndf = nrow(df)
mdf = ncol(df)
Close = df[,2:mdf] #剔除日期列
Ret = matrix(rep(0,(ndf-1)*(mdf-1)),nrow = (ndf-1), ncol = (mdf-1))
for(i in 1:(mdf-1)){
  print(i)
  oneclose = Close[,i]
  ret = diff(oneclose)/oneclose[1:(ndf-1)]
  Ret[,i] = ret
}

w = RiskParity(Ret)