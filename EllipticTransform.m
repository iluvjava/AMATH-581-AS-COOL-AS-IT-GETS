function [Xs, Ys] = EllipticTransform(xs, ys, theta, ecc)
    % Rotate gridpoint by theta, and stretch it along the direction with
    % ecc. 
    % xs, ys: Linsapce vector, has to be a Vector! 
    % theta: Rotation on the elliptic Gaussian
    % ecc: Eccentricity of the eclipse, stretch along the xaxis after the
    % transformation. 
    % mag: The magnitude of the Gaussian distribution. 
    
    [Xblock, Yblock] = meshgrid(xs, ys);
    ScaleMatrix      = [ecc, 0; 0, 1];
    RotationMatrix   = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    I = eye(length(xs));
    XyStacked = [Xblock; Yblock];
    OperationMatrix  = kron(ScaleMatrix, I)*kron(RotationMatrix, I);
    XyTransformed    = OperationMatrix*XyStacked;
    Xs = XyTransformed(1: length(xs), :);
    Ys = XyTransformed(length(xs) + 1: end, :);
end