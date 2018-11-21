function [map] = get_hilbert_map(binmap)




end

function grad_negativeloglikelyhood(X, Y)

    

end

function p = occupancyProb(w, X)
    % Probability that y = 1
    p = 1/(1+exp(dot(w, kernelFeatures(X, X_data))); 

end

function phi_hat = kernelFeatures(X, X_data, option)
    % X : Query point
    % X_data : Sample points
   phi_hat = zeros(size(X_data, 1), 1);
   
   switch option
       case 'sparse'
           for i = 1:size(X_data)     
               phi_hat = [phi_hat; kSparse(X_data(i, :))];
       
           end
           
       case 'threshold'
           for i = 1:size(X_data)
               phi_hat = [phi_hat; kThreshold(X_data(i, :))];
           end
           
   end

end

function k = kSparse(x)
    k= 0;
    omega = eye(2); % Omega is positive semi definite
    
    r = sqrt((x-x_sample)'*omega*(x-x_sample));
    
    if r < 1
        k = 2 + cos(2*pi()*r)*(1-r)/3 + sin(2*pi()*r)/(2*pi());
        
    end
end

function k = kThreshold(x)
    k= 0;

    omega = eye(2); % Omega is positive semi definite
    
    r = norm(x-x_sample);
    rth = 1.0;
    
    if r < rth
        k = rth - r / rth;
        
    end
end