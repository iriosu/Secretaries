using PyPlot

function EvaluatePolicy(S,N,m, theta=nothing)
    if theta == nothing
        theta = rand(S,N)
    end
    println("Solving for m=", m)
    # without buy back
    oracle = zeros(S)
    policy = zeros(S)
    for s in 1:S
        # choose candidate among first m-1 applicants
        vc = max(theta[s,1:m-1]...)
        println(vc)
        mx = 0
        for i in m:N
            if theta[s,i] >= vc
                mx = theta[s,i]
                break
            end
        end
        if mx == 0
            mx = theta[s,N]
        end
        policy[s] = mx
        oracle[s] = max(theta[s,1:N]...)
        println(oracle[s], " ", policy[s])
    end
    # compute averages over simulation
    avg_policy = mean(policy)
    avg_oracle = mean(oracle)
    return avg_policy, avg_oracle
end

# INPUTS #
S = 500 # number of simulations
N = 16 # number of secretaries
# m = 4 # number of first applicant that could potentially be chosen after exploration
theta = rand(S,N)

# EXECUTION #
policy = zeros(N-1)
oracle = zeros(N-1)
for m in 2:N
    policy[m-1], oracle[m-1] = EvaluatePolicy(S,N,m,theta)
end

ds = 2:N
plot(ds, [oracle[s-1] for s in ds], linestyle="--",marker="o")
plot(ds, [policy[s-1] for s in ds], linestyle="-",marker="o")
xlabel("First hirable applicant")
ylabel("Objective")
show()
