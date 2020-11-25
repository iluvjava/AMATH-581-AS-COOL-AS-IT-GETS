classdef PsiGuess < handle
    % A reference to the initial guess for the Psi so that iterative method
    % converges faster. 
    
    properties
        Psi  % The prevously solved Psi. 
    end
    
    methods
        function obj = PsiGuess()
            
        end
    end
end

