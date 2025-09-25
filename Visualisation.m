data_1 = readtable("MonzaQualiLEC.csv");
data_2 = readtable("MonzaRaceLEC.csv");

% Set the Distance Axis
maxDist = min(max(data_1.Distance),max(data_2.Distance));
refDist = linspace(0,maxDist,2000);

% Getting Time Column
time_1 = erase(data_1.Time, "0 days ");
time_1 = duration(time_1, 'InputFormat', 'hh:mm:ss.SSS');
time_1 = seconds(time_1);
time_1 = interp1(data_1.Distance, time_1, refDist, "linear");

time_2 = erase(data_2.Time, "0 days ");
time_2 = duration(time_2, 'InputFormat', 'hh:mm:ss.SSS');
time_2 = seconds(time_2);
time_2 = interp1(data_2.Distance, time_2, refDist, "linear");

%% Get Variable Data
% Position
x_pos_1 = interp1(data_1.Distance, data_1.X, refDist, "linear");
y_pos_1 = interp1(data_1.Distance, data_1.Y, refDist, "linear");

x_pos_2 = interp1(data_2.Distance, data_2.X, refDist, "linear");
y_pos_2 = interp1(data_2.Distance, data_2.Y, refDist, "linear");

% Speed
speed_1 = interp1(data_1.Distance, data_1.Speed, refDist, "linear");
speed_2 = interp1(data_2.Distance, data_2.Speed, refDist, "linear");

% Brake
brake_1 = string(data_1.Brake);
brake_1 = brake_1 == "True";
brake_1 = double(brake_1);
brake_1 = interp1(data_1.Distance, brake_1, refDist, "nearest");

brake_2 = string(data_2.Brake);
brake_2 = brake_2 == "True";
brake_2 = double(brake_2);
brake_2 = interp1(data_2.Distance, brake_2, refDist, "nearest");

% Throttle
throttle_1 = interp1(data_1.Distance, data_1.Throttle, refDist, "linear");
throttle_2 = interp1(data_2.Distance, data_2.Throttle, refDist, "linear");

% Gear
gear_1 = interp1(data_1.Distance, data_1.nGear, refDist, "nearest");
gear_2 = interp1(data_2.Distance, data_2.nGear, refDist, "nearest");

%% Plotting Track and Car on Fig 1
trackplot1 = figure(1);
ax1 = axes(trackplot1);
plot(ax1,x_pos_1,y_pos_1,'k','LineWidth',1)
hold (ax1,'on')
car_1 = plot(ax1,x_pos_1(1),y_pos_1(1),'o','MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10);
hold (ax1,'off')
axis (ax1,'equal')
axis (ax1,'off')
title('Quali')

%% Plotting Track and Car on Fig 2
trackplot2 = figure(2);
ax2 = axes(trackplot2);
plot(ax2,x_pos_2,y_pos_2,'k','LineWidth',1)
hold (ax2,'on')
car_2 = plot(ax2,x_pos_2(1),y_pos_2(1),'o','MarkerFaceColor','r','MarkerSize',10);
hold (ax2,'off')
axis (ax2,'equal')
axis (ax2,'off')
title('Race')


%% Plotting Telemetry 1
figure(3)
% Speed Plot
speedplot = subplot(3,1,2);
splot_1 = plot(speedplot,refDist,speed_1,'b');
hold on
splot_2 = plot(speedplot,refDist,speed_2,'r');
hold off
xlim([0 6000])
ylim([0 400])
title('Speed [km/h]')
grid on

% Brake Plot
brakeplot = subplot(3,1,3);
bplot_1 = plot(brakeplot,refDist,brake_1,'b');
hold on
bplot_2 = plot(brakeplot,refDist,brake_2,'r');
hold off
xlim([0 6000])
ylim([-0.1 1.1])
title('Brake Input [0-1]')
grid on

% Plotting Delta
delta = time_1 - time_2;
timeplot = subplot(3,1,1);
timeplot_1 = plot(timeplot,refDist,delta,'k');
xlim([0 6000])
ylim([-5 5])
title('Delta [s]')
grid on

%% Plotting Telemetry 2
figure(4)
% Throttle Plot
throttleplot = subplot(2,1,1);
tplot_1 = plot(throttleplot,refDist,throttle_1,'b');
hold on
tplot_2 = plot(throttleplot,refDist,throttle_2,'r');
hold off
xlim([0 6000])
ylim([-10 110])
title('Throttle Input [0-100]')
grid on

% Gear Plot
gearplot = subplot(2,1,2);
gplot_1 = plot(gearplot,refDist,gear_1,'b');
hold on
gplot_2 = plot(gearplot,refDist,gear_2,'r');
hold off
xlim([0 6000])
ylim([-1 9])
title('Gear')
grid on

%% Updating Data
for i = 2:length(refDist)
    % For Driver 1
    car_1.XData = x_pos_1(i);
    car_1.YData = y_pos_1(i);
    
    splot_1.XData = refDist(1:i);
    splot_1.YData = speed_1(1:i);

    tplot_1.XData = refDist(1:i);
    tplot_1.YData = throttle_1(1:i);

    bplot_1.XData = refDist(1:i);
    bplot_1.YData = brake_1(1:i);

    gplot_1.XData = refDist(1:i);
    gplot_1.YData = gear_1(1:i);
    
    % For Driver 2
    car_2.XData = x_pos_2(i);
    car_2.YData = y_pos_2(i);
    
    splot_2.XData = refDist(1:i);
    splot_2.YData = speed_2(1:i);

    tplot_2.XData = refDist(1:i);
    tplot_2.YData = throttle_2(1:i);

    bplot_2.XData = refDist(1:i);
    bplot_2.YData = brake_2(1:i);

    gplot_2.XData = refDist(1:i);
    gplot_2.YData = gear_2(1:i);

    % Delta
    timeplot_1.XData = refDist(1:i);
    timeplot_1.YData = delta(1:i);

    drawnow
    pause(0.000001*(time_2(i)-time_2(i-1)))
end