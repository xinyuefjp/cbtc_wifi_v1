function bool = save2mysql(myObject, myEventdata)
% 静态变量，用于记录需要几段不同的场景的轨道
    persistent count;
    if isempty(count)
        count = 0;
    end
    conc = database('netdesign', 'root', '123', 'com.mysql.jdbc.Driver', 'jdbc:mysql://localhost:3306/netdesign');
    
    count = count + 1;
    % --- 存入myObject.myTrack的数据
    bool = exec(conc, "insert into mytrack " ...
     + "(trackx, tracky, trackpoint, trackn, myinterval,step, linecell, circlecell) " ...
     + "values" + "(" + "'" + mat2combstr(myObject.myTrack.TrackX) + "'" ...
     + "," + "'" + mat2combstr(myObject.myTrack.TrackY) + "'" + "," ...
     + myObject.myTrack.TrackPoint + "," + myObject.myTrack.TrackN + "," + myObject.myTrack.Interval + "," + myObject.myTrack.Step ...
     + "," + "'" + mat2combstr(cell2mat(myObject.myTrack.LineCell)) + "'" + "," ...
     + "'" + mat2combstr(cell2mat(myObject.myTrack.CircleCell)) + "'" + ")");
 
    % --- 存入myObject.myRtx的数据
    bool = exec(conc, "insert into myrtx" ...
        + "(mattx, matrx, apx, apy, signalfre, threshold, aprange)" ...
        + "values" + "(" + "'" + mat2combstr(myObject.myRtx.MatTx) + "'" + "," ...
        + "'" + mat2combstr(myObject.myRtx.MatRx) + "'" + "," ...
        + "'" + mat2combstr(myObject.myRtx.ApX) + "'" + "," ...
        + "'" + mat2combstr(myObject.myRtx.ApY) + "'" + "," ...
        + myObject.myRtx.signalFre + "," ...  % signalFre在数据库中是char(10)，matlab中是2e6，自动被转为2000000
        + myObject.myRtx.Threshold + "," ...
        + "'" + mat2combstr(myObject.myRtx.ApRange) + "'" + ")");
    
    % ---存入myObject.myInterf的数据
    bool = exec(conc, "insert into myInterf" ...
        + "(Interf1, Interf2, Interfx, InterfY, NoisePower, MatTx)" ...
        + "values" + "(" + "'" + mat2combstr(myObject.myInterf.Interf1) + "'" + "," ...
        + "'" + mat2combstr(myObject.myInterf.Interf2) + "'" + "," ...
        + "'" + mat2combstr(myObject.myInterf.InterfX) + "'" + "," ...
        + "'" + mat2combstr(myObject.myInterf.InterfY) + "'" + "," ...
        + myObject.myInterf.NoisePower + "," ...
        + "'" + mat2combstr(myObject.myInterf.MatTx) + "'" + ")");
    
    % ---存入myObject.myCost的数据
    bool = exec(conc, "insert into mycost" ...
        + "(alpha, beta, gama)" ...
        + "values" + "(" + myObject.myCost.alpha + "," ...
        + myObject.myCost.beta + "," ...
        + myObject.myCost.gama + ")");

    % ---存入myObject.myScene的数据
    bool = exec(conc, "insert into myScene" ...
        + "(myCurrentScene)" ...
        + "values" + "(" +  "'" + myObject.myScene.myCurrentScene + "'" + ")");
    
    close(conc);
end