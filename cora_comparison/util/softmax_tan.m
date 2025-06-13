function out = softmax_tan(in, bounds)
    out = bounds .* tanh(in ./ bounds);
end