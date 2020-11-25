function Psi = SolveForPsi(params, w)

    Psi = 0;
    A2  = params.A2;  % This is the matrix we wanna solve. 
    L   = params.L;
    U   = params.U;
    P   = params.P;
    tic;
    switch params.SolveModes
        
        case 0
            error("Please specify solver for Stream function.");
        case 1 % BackSlash
            Psi = A2\w;
            
        case 2 % LU
            Psi = U\(L\(P*w));
            
        case 3 % Biconjugate Gradient Stabalized method. 
            if length(params.LastGuess.Psi) ~=  length(w)
                Psi = bicgstab(A2, w, params.BicgstabTOL, params.BicgstabItr);
            else
                Psi = bicgstab(A2, w, params.BicgstabTOL, params.BicgstabItr, ... 
                    [], [], params.LastGuess.Psi);
            end 
            params.LastGuess.Psi = Psi;
            
        case 4 % GMRES 
            if length(params.LastGuess.Psi) ~=  length(w)
               Psi = gmres(A2, w, [], params.GemresTOL, params.GmresItr);
            else
               Psi = gmres(A2, w, [], params.GemresTOL, ... 
                    params.GmresItr, [], [], params.LastGuess.Psi);
            end
            params.LastGuess.Psi = Psi;
            
        case 5 % FFT 2D Solve
            N = params.n;
            L = params.l;  % L changed, not the L for LU decomposition anymore
            w = reshape(w, N, N);
            WFourier = fft2(w);
            kx = fftshift((2*pi/L).*(-N/2: (N/2 - 1)));
            kx(1) = 1e-6;
            ky = kx';
            Psi = real(ifft2(-WFourier./(kx.^2 + ky.^2)));
            Psi = reshape(Psi, N^2, 1);
    end
    Timepassed = toc;
    disp(strcat("Time Passed: ", num2str(Timepassed)));
    params.TimeStats.add(Timepassed);
end

% function trimmed = TrimOffBoundary(w)
%   % Trim off the boundary from the matrix, the last row/column of the
%   % matrix. 
%   trimmed = w(1: end - 1, 1: end - 1);
% end
% 
% function PadBoundary = PadBoundary(w)
%   % Pad the last row, last column of the matrix with the first row and the
%   % first column. 
%   PadBoundary = w; 
%   PadBoundary(:, end + 1) = w(:, 1);
%   PadBoundary(end + 1, :) = w(1, :);
% end