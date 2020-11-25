classdef Parameters
    % PARAMS Summary of this class goes here
    %   This is a class handle and it's shared among differnt methods.   
    
    
    properties
        A;  % Partial x operational matrix.
        B;  % Partial y operational matrix.
        C;  % Laplacian operational matrix.
        A2; % Laplacian for solving the Stream function matrix.
        SolveModes = 0; 
            % What is the mode for solving for the stream function? 
            % 1. Back Slash (Implemented)
            % 2. LU decomposition (Implemented)
            % 3. bicgstab 
            % 4. gmres
            % 5. FFT spectral method
            
        % These parameters are for solving the Stream function using LU
        % decomposition. 
        L;  U;  P;
        
        % This part is for statistics and bench marking the algorithm. 
        TimeStats;  % java object is mutable! 
        
        % Miscs
        n; % Grid discritization. 
        l; % length of the axis, for both x and y, this is for FFT. 
        GemresTOL = 1e-6; 
        BicgstabTOL = 1e-6; 
        BicgstabItr = 500;
        GmresItr = 400;
        LastGuess = PsiGuess();
        xs;
        ys;
    end
    
    methods 
        function obj = Parameters(n, deltaX)
                obj.n = n;
                P  = FiniteDiffMatrix([-1, 0, 1], [-1, 0, 1], n);
                PartialX  = kron(P, eye(n))./(2*deltaX);
                PartialY  = kron(eye(n), P)./(2*deltaX);
                
                P2 = FiniteDiffMatrix([1, -2, 1], [-1, 0, 1], n);
                Laplacian = kron(P2, eye(n)) + kron(eye(n), P2);
                Laplacian = Laplacian./(deltaX^2);
                obj.A  = Laplacian;
                obj.B  = PartialX;
                obj.C  = PartialY;
                obj.A2 = Laplacian;
                obj.A2(1, 1) = 2/deltaX^2;  % Modifications on the Laplacian. 
            if n <= 128  % Only LU if this is not too beig 
                [obj.L, obj.U, obj.P] = lu(obj.A2);
            end
            import java.util.ArrayList;
            obj.TimeStats = ArrayList();
        end
    end
    
end

