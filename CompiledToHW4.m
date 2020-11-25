% Organized the solutions for HW4 and ready to put them into a template for
% submitting. 
% Files Included: 
% 1. This file
% 2. FiniteDiffMatrix
% 3. Parameters.m
%   3.1. PsiGuess. 
% 4. Rhs.m
% 5. SolveForPsi.m
% 6. VectorizedInitialDistribution.m
% 
% Pre submit checks: Completed. 
% First Trial: 
% Status: Failed. 
%   Reason 1: 
%       Grid discritization DeltaX is incorrect, it should be 20/63, because
%   there are 63 intervals, and 64 points for discritization. 
%       ! ADDRESSED
%   Reason 2: 
%       Use the modified A for both advancing the omega function, and
%       solving for the stream function. 
%       (This might not be a contributing factor because of small 0.001 for diffusion)
%
%
% Second Trial: 
%   Status: All Failed.
%   Reason: 
%       1. Confirmed by reading the textbook, there is something wrong with
%       the grid points, and the boundary conditions is not addressed. 
%       And this will also place my FFT for first submission even if that
%       FFT handles the boundary condition differently. 
%       
%       For FFT, we need a better soluton. 
%
% Third Trial: 
%   Status: All Failed. 
%   Reason: 
%       1. The boundary points ARE NOT Included! The matrix took care of
%       that already. 

clear variables

n      = 64;
L      = 20; 
DeltaX = L/n;
AA     = zeros(9, n^2, 5);  % To store all solutions.
xs     = -L/2 : DeltaX: L/2 - DeltaX;
ys     = -L/2 : DeltaX: L/2 - DeltaX; 

Params   = Parameters(n, DeltaX);
Params.l = 20;  % For fft.
InitialDistribution = @(x, y) exp(-x.^2 - y.^2./20);
w_vec = VectorizeInitialDistribution(xs, ys, InitialDistribution);

for I = 1:5
    Tspan = 0: 0.5: 4;
    Params.SolveModes = I; 
    % Setting Options for solving and stuff. 
    
    % Solving
    ODEFun = @(t, w) Rhs(w, Params);
    [~, Ws] = ode45(ODEFun, Tspan, w_vec);
    AA(:, :, I) = Ws;
end

A1 = AA(:, :, 1);
A2 = AA(:, :, 2);
A3 = AA(:, :, 3);
A4 = AA(:, :, 4);
A5 = AA(:, :, 5);


%% 
% Plotting the data out. 
% figure(1); imagesc(reshape(A1(9, :), 64, 64)); colorbar; title("A1");
% figure(2); imagesc(reshape(A2(9, :), 64, 64)); colorbar; title("A2");
% figure(3); imagesc(reshape(A3(9, :), 64, 64)); colorbar; title("A3");
% figure(4); imagesc(reshape(A4(9, :), 64, 64)); colorbar; title("A4");
% figure(5); imagesc(reshape(A5(9, :), 64, 64)); colorbar; title("A5");

PlotSimulations(A1, 1);
PlotSimulations(A2, 2);
PlotSimulations(A3, 3);
PlotSimulations(A4, 4);
PlotSimulations(A5, 5);

%% Functions 

function Argout = PlotSimulations(Dat, t)
    % Stitch all of them together. 
    TotalMatrix = zeros(64*3, 64*3);
    figure(t);
    for I = 0: 8
        m = floor(I/3);
        n = mod(I, 3);
        TotalMatrix(m*64 + 1: (m + 1)*64, n*64 + 1: (n + 1)*64) ... 
            = reshape(Dat(I + 1, :), 64, 64);
    end
    pcolor(TotalMatrix);
    shading interp;
    title(strcat("A", num2str(t)));
end


% function argout = TrimOffBoundary(dat, n)
%     m = size(dat, 1);
%     argout = zeros(m, (n - 1)^2);
%     for I = 1: m
%         argout(I, :) = Helper(dat(I, :), n);
%     end
%     
%     function argOut = Helper(w, n)
%         % Trim off the first, last row of the vectorized matrix, and put them
%         % back to vector, for submission. 
%         M = reshape(w, n, n);
%         M = M(1: end - 1, 1: end - 1);
%         argOut = reshape(M, (n - 1)^2, 1);
%     end
% 
% end