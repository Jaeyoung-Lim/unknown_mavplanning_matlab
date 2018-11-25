function grad_NLL = grad_negativell(param, w, X, Y, map)

grad_NLL = zeros(size(w));
for i = 1:size(Y, 1) % TODO: vectorize this calculation
%     tic;
    phi_x = kernelFeatures(param, X(i, :), map, param.hilbertmap.kernel);
%     time = toc;
%     fprintf('Kerenel calculation Time: %d\n',time)
    grad_NLL = grad_NLL -Y(i)* phi_x / ( 1 + exp(Y(i)*dot(w, phi_x)));
end

end