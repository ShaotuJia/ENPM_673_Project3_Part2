% This function is to check whether the decompose R and S are valid results

function bool = Valid_RS(R, S, E)

%Admissable error
%{
error = 0.1;
if ((transpose(R) * R - 1)<error) && ((S * R - E)<error)  
    bool = true;
else
    bool = false;

end
%}
%TEST
bool = false;

end