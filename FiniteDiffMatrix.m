function P = FiniteDiffMatrix(filter, diagonalPosition, n)
    % This is a smart function that is going to construct the differential
    % matrix for you, assumning a periodic boundary conditions. It will
    %
    % Filter: 
    %   This is the finite differnce coefficients. SHOULD BE ROW VECTOR.
    %
    % diagonalPosition: 
    %   This represent where the finite different coefficients is applied
    %   to the sampled points.
    if length(filter) ~= length(diagonalPosition)
        error("Please check you input, the number of diagonal equals to the finite diff coefficients.");
    end
    
    e       = ones(n, 1);
    P       = spdiags(e.*filter, diagonalPosition, n, n);
    NewDiag = zeros(size(filter));
    
    % Handle Periodic Conditions. 
    for I = 1: length(NewDiag)
       if diagonalPosition(I) < 0
           NewDiag(I) = (n + diagonalPosition(I));
        
       elseif diagonalPosition(I) > 0
           NewDiag(I) = -(n - diagonalPosition(I));
       else
           filter(I) = 0;  % No overlap. 
       end
    end
    P = P + spdiags(e.*filter, NewDiag, n, n);
end