function result = notConverged(pz, pz2, k, err)
    for i = 1:k
        if abs(pz2(i)-pz(i))>err
            result = true;
            disp(['result = ' num2str(result)]);
            return;
        end
    end
    result = false;
    disp(['result = ' num2str(result)]);
end