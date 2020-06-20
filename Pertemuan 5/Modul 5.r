library(dslabs)
data("murders")
murder_rate = murders$total / murders$population*10000
ind = which.min(murder_rate)

avg = function(x){
  n = length(x)
  print(n)
}

compute_s_n = function(n){
  x = 1:n
  sum(x)
}

klasifikasi = function(a){
  if(a > 10000000){
    print("BESAR")
  }else if(a > 1000000){
    print("SEDANG")
  }else
    print("KECIL")
}

for (i in 1:5) {
  print(i)
}
