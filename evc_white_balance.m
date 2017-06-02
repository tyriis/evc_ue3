%
% Copyright 2017 Vienna University of Technology.
% Institute of Computer Graphics and Algorithms.
%

function [result] = evc_white_balance(input, white)
%evc_white_balance performs white balancing manually.

%   INPUT
%   input       ... image
%   white       ... a color (as RGB vector) that should become the new white

%   OUTPUT
%   result      ... result after white balance
 
    %NOTE:  pixels brighter than 'white' will have values > 1.
    %       This requires a normalization which will be performed
    %       during the histogram clipping. 
	
	%HINT: Make sure the program does not crash if 'white' is zero!
    result = input;
    if white(1) <= 0
        white(1) = 0.0000000001;
    end
    if white(2) <= 0
        white(2) = 0.0000000001;
    end
    if white(3) <= 0
        white(3) = 0.0000000001;
    end
    result(:,:,1) = input(:,:,1) / white(1);
    result(:,:,2) = input(:,:,2) / white(2);
    result(:,:,3) = input(:,:,3) / white(3);
    
end