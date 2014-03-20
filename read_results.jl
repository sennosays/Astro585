num_evals = 1; 
nentries = 1; 

#length(ARGS) == 0 ? name = "time_results.txt" : name = ARGS[1];
name = "time_results.txt";

fp = open(name,"r"); 
num_evals = read(fp,Int64,1); 
error = read(fp,Float64,1);
nentries = read(fp,Int,1)[1]; 
nump=read(fp,Int64,nentries);
times=read(fp,Float64,nentries);
close(fp); 

using PyPlot

println("Using ",num_evals," evaluations there was a maximum error between runs found to be ",error); 
plot(nump,times); 
title("Execution Time per Number of Workers");
ylabel("Time (s)")
xlabel("Number of Workers"); 
