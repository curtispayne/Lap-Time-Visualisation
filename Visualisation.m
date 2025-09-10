data = readtable("data.csv");

%% Get Position Data
x_pos = data.X;
y_pos = data.Y;

%% Plotting Track
trackplot = subplot(4,2,[2 4 6 8])
plot(trackplot,x_pos,y_pos,'k','LineWidth',1)
hold on
axis equal
axis off

%% Plotting Car
car = plot(trackplot,x_pos(1),y_pos(1),'o','MarkerFaceColor','r','MarkerSize',10)

%% Plotting Telemetry
% Time Axis
time = erase(data.Time, "0 days ");
time = duration(time, 'InputFormat', 'hh:mm:ss.SSS');
time = seconds(time);

% Speed, Throttle, and Gear Data
speed = data.Speed;
throttle = data.Throttle;
gear = data.nGear;

% Brake Data
brake = string(data.Brake);
brake = brake == "TRUE";
brake = double(brake);

% Speed Plot
speedplot = subplot(4,2,1)
splot = plot(speedplot,time,speed,'k')
xlim([0 90])
ylim([0 350])
title('Speed [km/h]')
grid on

% Throttle Plot
throttleplot = subplot(4,2,5)
tplot = plot(throttleplot,time,throttle,'b')
xlim([0 90])
ylim([-10 110])
title('Throttle Input [0-100]')
grid on

% Brake Plot
brakeplot = subplot(4,2,7)
bplot = plot(brakeplot,time,brake,'r')
xlim([0 90])
ylim([-0.1 1.1])
title('Brake Input [0-1]')
grid on

% Gear Plot
gearplot = subplot(4,2,3)
gplot = plot(gearplot,time,gear,'k')
xlim([0 90])
ylim([-1 9])
title('Gear')
grid on

%% Updating Data
for i = 2:length(x_pos)
    car.XData = x_pos(i);
    car.YData = y_pos(i);
    
    splot.XData = time(1:i);
    splot.YData = speed(1:i);

    tplot.XData = time(1:i);
    tplot.YData = throttle(1:i);

    bplot.XData = time(1:i);
    bplot.YData = brake(1:i);

    gplot.XData = time(1:i);
    gplot.YData = gear(1:i);

    drawnow
    pause(time(i)-time(i-1))
end