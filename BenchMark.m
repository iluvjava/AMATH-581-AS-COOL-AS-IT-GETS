% Investigate the average speed of solving things
% In terms of complexity, Backslash is going to lose and FFT should win. 

clear variables
% delete(gcp('nocreate'));  

AverageTime = RunSolvingRoutine(64, 0: 0.1: 10);
disp(AverageTime);

%% 
figure;
Xaxis = categorical(["BackSlash Solver", "LU Solver", "BiCGStab", "Gmres", "FFT Spectral"]);
bar(Xaxis, AverageTime);
title("Average time over ODE45");
ylabel("Seconds");
saveas(gcf, "benchmarkresult", "png");

function AverageTimes = RunSolvingRoutine(n, Tspan)
    % Compute the average time for the given configuration of simulation. 

    xs = linspace(-10, 10, n);
    ys = linspace(-10, 10, n); 
    
    AverageTimes = zeros(1, 5);
    
    Params = Parameters(n, 20/n);
    Params.l = 20;  % For fft.
    InitialDistribution = @(x, y) exp(-x.^2 - (y.^2./20));
    w_vec = VectorizeInitialDistribution(xs, ys, InitialDistribution);

    ParameterInstance = cell(1, 5); 
    for I = 1: 5
        Temp = Params;
        Temp.SolveModes = I;
        ParameterInstance{I} = Temp;
    end
    
    for I = [1, 2, 3, 4, 5]
        Params = ParameterInstance{I};
        % Setting Options for solving and stuff. 
        % Solving
        ODEFun = @(t, w) Rhs(w, Params);
        [Ts, Ws] = ode45(ODEFun, Tspan, w_vec);
        
        % Store the performance data
        Dat = zeros(1, Params.TimeStats.size);
        for J = 1 : Params.TimeStats.size
            Dat(J) = Params.TimeStats.get(J - 1); 
        end
        Params.TimeStats.clear();
        AverageTimes(I) = mean(Dat);
    end
    
end