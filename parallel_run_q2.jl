#Pkg.add("Distributions"); 


#function which finds the max error between
#the parallel results and the serail results 
#because the calculations use random numbers 
#this error should go as num_evals^-1/2 
#input is the results matrix
function check_results(r::Array{Any,3})
	serial_result = copy(r[1]);
	max_error = 0.0;  
	for i in 2:length(r[:,1,1])
		max_error = maximum(r[i] .- serial_result); 
	end
	max_error
end

min_eta = 0.0
max_eta = 1.0
min_shape = 0.0001
max_shape = 1.0
min_log_scale = log10(0.3)
max_log_scale = log10(3.0)  
num_eta = 4 
num_shape = 4
num_scale = 4
num_evals = 1 	#number of evaluations is taken as an argument 
etas = linspace(min_eta,max_eta,num_eta)
scales = 10.0.^linspace(min_log_scale,max_log_scale,num_scale)
shapes = linspace(min_shape,max_shape,num_shape)
num_stars = 16000
eta = 0.2
shape = 0.1
scale = 1.0;

#list of the number of processes on a larger machine like lionxj
#nump = [1,2,4,6,8];

#only need two processes for a smaller workstation
#if up to 8 processes are desired used the above line
nump = [1,2]; 

times = Array(Float64,length(nump)); 
results = cell(length(nump),num_scale,num_shape);  

srand(42)

index = 1; 
for np in nump
	reload("q2_once"); 
	@everywhere include("parallel_q2.jl"); 
	@assert(np == nworkers()); 
	println("running on ",np," core(s)"); 
	tic(); 
	result = eval_model_on_grid_loops(etas,shapes,scales,num_stars, num_evals = num_evals, true_eta = eta, true_shape = shape, 			true_scale = scale);
	times[index] = toc(); 
	results[index] = [minimum(result[:,j,k]) for j in 1:num_scale, k in 1:num_shape];
	index = index +1; 
	addprocs(2); 
end
my_error = check_results(results);
typeof(my_error);
fp = open("time_results.txt","w+"); 
write(fp,num_evals); 
write(fp,my_error); 
write(fp,length(nump)); 
write(fp,nump); 
write(fp,times); 
close(fp); 

println("Max error was found to be ",my_error); 
 

#PyPlot.contour(log10(scales),shapes,[minimum(result[:,j,k]) for j in 1:num_scale, k in 1:num_shape])
#plot(log10([scale]),[shape],"ro")  # Put dot where true values of parameters are
#xlabel(L"$\log_{10}(\mathrm{scale})$");  ylabel("shape");
#[minimum(result[:,j,k]) for j in 1:num_scale, k in 1:num_shape]
