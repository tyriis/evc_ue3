%
% Copyright 2017 Vienna University of Technology.
% Institute of Computer Graphics and Algorithms.
%

function [result] = evc_compute_binary(input, x, top)
%evc_compute_binary computes a binary image with the specified threshold x.
%
%   INPUT
%   input ... RGB image
%   x     ... scalar threshold
%   top   ... if 0, the output should be inverted such that 0 becomes 1 
%             and 1 becomes 0.
%   OUTPUT
%   result... binary RGB image which must contain either zeros or ones. The
%             result has to be of type double! Make sure that all three 
%             channels are preserved (the operation has to be performed on 
%             every channel).

	%NOTE:  The following line can be removed. It prevents the framework
    %       from crashing.
    if top
        result = double(input > x);
    else
        result = double(input < x);
    end
    %TODO: Compute a binary image with the threshold x. The input image 
    % might contain values greater than 1 so im2bw can't be used (it would 
    % crash).
    % If top == 0 the output should be inverted such that 0 becomes 1 and 
    % 1 becomes 0 (swap 0 and 1).
end
