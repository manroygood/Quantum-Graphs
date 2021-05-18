function z = qgdot(Phi,u1col,u2col)

if Phi.isUniform
    z = qgdotUnif(Phi,u1col,u2col);
else
    z = qgdotCheb(Phi,u1col,u2col);
end
