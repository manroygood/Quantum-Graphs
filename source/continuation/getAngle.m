function theta = getAngle(U1,U2,U3,v1,v2,v3,dotProduct)

dU1=U2-U1; dU2=U3-U2;
dv1=v2-v1; dv2=v3-v2;

bigdot=@(x1,x2,v1,v2) dotProduct.dot(x1,x2) + dotProduct.beta*v1*v2;

numer = bigdot(dU1,dU2,dv1,dv2);
denom1 = sqrt(bigdot(dU1,dU1,dv1,dv1));
denom2 = sqrt(bigdot(dU2,dU2,dv2,dv2));

cTheta = numer/denom1/denom2;
theta = acos(cTheta)*180/pi;