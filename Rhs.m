function dwdt = Rhs(omega, params)
    % This functions receives the omega, vorticity function, and then it
    % will return the next time-stepping for the vorticity function. 
    % 
    % w: 
    %   Vectorized vorticity function, x, columns, first, and then each of
    %   the sub vectors are the y, rows. 
    % params: 
    %   An instance of the Parameters class, so the function can take
    %   whatever parameters it needs from the class properties and apply
    %   then. 
    
    v = 0.001;
    A = params.A;
    A2 = params.A2;
    B = params.B;
    C = params.C;
    Psi = SolveForPsi(params, omega);
    % dwdt = -(B*Psi).*(C*omega) + (C*Psi).*(B*omega) + v.*(A*omega);
    dwdt = -(B*Psi).*(C*omega) + (C*Psi).*(B*omega) + v.*(A*omega);
end