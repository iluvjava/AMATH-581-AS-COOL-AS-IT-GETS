function result = VectorizeInitialDistribution(xs, ys, fxn)
    % The function receives the grid point, a function, and returns the
    % vectorized grid points for solving the system with scientific method.
    % It will be a column vector!
    % 
    % xs: 
    %   Grids for the x axis 
    % ys: 
    %   Grids for the y axis
    % fxn: 
    %   The function that turns the grid point into initial distribution of
    %   the vorticity function. 

    [Xs, Ys] = meshgrid(xs, ys);
    Zs       = fxn(Xs, Ys);
    m = length(xs); n = length(ys);
    result = reshape(Zs, m*n, 1);
end