function crossed = crossThresh(threshold,datavec,k)

crossed = (datavec(k)-threshold)*(datavec(1)-threshold)<0;