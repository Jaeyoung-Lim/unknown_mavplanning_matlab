function grad_NLL = grad_negativell(w, X, Y, map, kernel)

grad_NLL = zeros(size(w));
for i = 1:size(Y, 1)
%     tic;
    phi_x = kernelFeatures(X(i, :), map, kernel);
%     time = toc;
%     fprintf('Kerenel calculation Time: %d\n',time)
    grad_NLL = grad_NLL -Y(i)* phi_x / ( 1 + exp(Y(i)*dot(w, phi_x)));
end

end