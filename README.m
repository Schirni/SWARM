% Purpose: Investigation of natural hazards with magentic field measurements from low earth orbit
% Data:    ESA Swarm mission high res 50 Hz data
% Tool:    Variations around the event in a box (time span and spatial domain)
% Events:  In File "events_natural_hazards.m", update, expand or use own structure


% go to directory, update to own path
cd f:\Swarm_SW\         

%clear all; close all;  
events_natural_hazards; % load event file
V(2)                    % check event if necessary, here no. 2 

% select event and box size, here +- 13.5 deg
event=2;                                % select event, no. 2
swarm_event_latlong.event_span=13.5;    % select box size, spatial domain
swarm_event_latlong.lat=V(event).lat; 
swarm_event_latlong.long=V(event).long; 
swarm_event_latlong.mag=V(event).mag;  

% select time span +- around event, here +-1 day
days_around_event=1; 

% get Swarm data variations
[swarm, swarm_event_results] = swarm_event([str2num(V(event).time(1:4)), str2num(V(event).time(6:7)), str2num(V(event).time(9:10))],days_around_event,swarm_event_latlong);

% Swarm magnetic field variations, check the values, e.g., in a toolbox (signal, statistics, etc.)
AX=swarm_event_results.A.X.B_firstdiff_detrend_all; At=swarm_event_results.A.t;
BX=swarm_event_results.B.X.B_firstdiff_detrend_all; Bt=swarm_event_results.B.t;
CX=swarm_event_results.C.X.B_firstdiff_detrend_all; Ct=swarm_event_results.C.t;