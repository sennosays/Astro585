num_evals = 1; 
nentries = 1; 

if length(name) == 0
   name = "time_results.txt"
end

fp = open(name,"r"); 
num_evals = read(fp,Int64,1); 
error = read(fp,Float64,1);
nentries = read(fp,Int,1)[1]; 
nump=read(fp,Int64,nentries);
times=read(fp,Float64,nentries);
close(fp); 

print("Using ",num_evals," evaluations there was a maximum error between runs found to be ",error,'\n'); 
plot(nump,times); 
title("Execution Time per Number of Workers");
ylabel("Time (s)")
xlabel("Number of Workers"); 
