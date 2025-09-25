import fastf1
import pandas as np

session = fastf1.get_session(2025, 'Monza', 'R')
session.load(telemetry=True)

fast_lap = session.laps.pick_driver("LEC").pick_fastest()

telem_data = fast_lap.get_telemetry().add_distance()

nec_data = telem_data[["Time","RPM","Speed","nGear","Throttle","Brake","X","Y","Z","Distance"]]

nec_data.to_csv("MonzaRaceLEC.csv", index=False)