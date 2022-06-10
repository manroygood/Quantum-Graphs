function z = dot(G,column1,column2)

y=column1.*conj(column2);
z=G.integral(y);