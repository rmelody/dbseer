function conf = barzanCurveFit(func, trainX, trainY, lowConf, upConf, minStep, maxSteps)
totalSteps = 0;
assert(size(lowConf, 1) == 1 && size(upConf, 1) == 1 && size(minStep, 1) == 1 && size(maxSteps, 1) == 1, 'Config should be a row-vector');
assert(size(trainY,2)==1, 'We only accept 1-D as target values');

lowVal = func(lowConf, trainX);
upVal = func(upConf, trainX);

for col=1:size(lowConf,2)
    steps = 0;
    while abs(upConf(col)-lowConf(col)) > minStep(col) && steps <= maxSteps(col)
        steps = steps+1;
        totalSteps = totalSteps+1;
        
        lowErr = mean(abs(lowVal-trainY));
        if isnan(lowErr) 
            lowConf(col) = (lowConf(col) + upConf(col))/2;
            lowVal = func(lowConf, trainX);
            continue;
        end 
        
        upErr = mean(abs(upVal-trainY));
        if isnan(upErr) 
            upConf(col) = (lowConf(col) + upConf(col))/2;
            upVal = func(upConf, trainX);
            continue;
        end 
        
        if lowErr>upErr
            lowConf(col) = (lowConf(col) + upConf(col))/2;
            lowVal = func(lowConf, trainX);
        else
            upConf(col) = (lowConf(col) + upConf(col))/2;
            upVal = func(upConf, trainX);
        end
        fprintf(1, 'steps=%d, low=%s, up=%s, lowErr=%.2f, upErr=%.2f\n', ...
            steps, valueToString(lowConf), valueToString(upConf), lowErr, upErr);
    end
    
    if (steps > maxSteps(col))
        display(['Reached the maximum number of iterations: ' num2str(steps)]);
    else
        display(['Converged after ' num2str(steps) ' iterations for this column']);
    end
    
    conf = (upConf + lowConf)/2;
end

display(['Overall number of steps: ' num2str(totalSteps) ' iterations']);

end

