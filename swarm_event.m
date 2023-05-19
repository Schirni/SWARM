function [swarm, swarm_event] = swarm_event(event,span,swarm_event_latlong)
% FILE      : swarm_event.m
% PROGRAMMER: Chr. Schirninger
% PURPOSE   : SWARM m-file magnetic field, world map
% EXAMPLE   : events_natural_hazards; % load events
%             V(2);                   % select and check event, if necessary
%             event=2; swarm_event_latlong.lat=V(event).lat; swarm_event_latlong.long=V(event).long; swarm_event_latlong.mag=V(event).mag; swarm_event_latlong.event_span=13.5; % event and box size, +- 13.5 deg
%             [swarm, swarm_event_results] = swarm_event([str2num(V(event).time(1:4)), str2num(V(event).time(6:7)), str2num(V(event).time(9:10))],1,swarm_event_latlong);       % Swarm data, timespan here +-1 day
% FUNCTIONS : read_swarm_ftp.m
% VERSION   : May 2023
% HISTORY   : 
;
d=[]; 
date_range=[datenum(event)-span:1:datenum(event)+span]; 
date_yyyymmdd=datestr(date_range,30); 
for k=1:1:length(date_range); 
  string4ftp=['*',date_yyyymmdd(k,1:8),'*']; 
  d_struct=read_swarm_ftp(string4ftp);                     % for magnetic field 50 Hz
  d=[d,d_struct]; 
end
;
% clear, separate cases
t_all=[]; for k=1:1:length(d); t_all=[t_all, d(k).A.t]; end; swarm.A.t=t_all'; clear t_all;
t_all=[]; for k=1:1:length(d); t_all=[t_all, d(k).B.t]; end; swarm.B.t=t_all'; clear t_all;
t_all=[]; for k=1:1:length(d); t_all=[t_all, d(k).C.t]; end; swarm.C.t=t_all'; clear t_all;
lat_all=[]; for k=1:1:length(d); lat_all=[lat_all, d(k).A.lat]; end; swarm.A.lat_all=lat_all'; clear lat_all;
lat_all=[]; for k=1:1:length(d); lat_all=[lat_all, d(k).B.lat]; end; swarm.B.lat_all=lat_all'; clear lat_all;
lat_all=[]; for k=1:1:length(d); lat_all=[lat_all, d(k).C.lat]; end; swarm.C.lat_all=lat_all'; clear lat_all;
long_all=[]; for k=1:1:length(d); long_all=[long_all, d(k).A.long]; end; swarm.A.long_all=long_all'; clear long_all;
long_all=[]; for k=1:1:length(d); long_all=[long_all, d(k).B.long]; end; swarm.B.long_all=long_all'; clear long_all;
long_all=[]; for k=1:1:length(d); long_all=[long_all, d(k).C.long]; end; swarm.C.long_all=long_all'; clear long_all;
R_all=[]; for k=1:1:length(d); R_all=[R_all, d(k).A.rad]; end; swarm.A.R_all=R_all'; clear R_all;
R_all=[]; for k=1:1:length(d); R_all=[R_all, d(k).B.rad]; end; swarm.B.R_all=R_all'; clear R_all;
R_all=[]; for k=1:1:length(d); R_all=[R_all, d(k).C.rad]; end; swarm.C.R_all=R_all'; clear R_all;
Babs_all=[]; for k=1:1:length(d); Babs_all=[Babs_all, d(k).A.Babs]; end; swarm.A.Babs_all=Babs_all'; clear Babs_all;
Babs_all=[]; for k=1:1:length(d); Babs_all=[Babs_all, d(k).B.Babs]; end; swarm.B.Babs_all=Babs_all'; clear Babs_all;
Babs_all=[]; for k=1:1:length(d); Babs_all=[Babs_all, d(k).C.Babs]; end; swarm.C.Babs_all=Babs_all'; clear Babs_all;
B_all=[]; for k=1:1:length(d); B_all=[B_all, d(k).A.B]; end; swarm.A.B_all=B_all'; clear B_all;
B_all=[]; for k=1:1:length(d); B_all=[B_all, d(k).B.B]; end; swarm.B.B_all=B_all'; clear B_all;
B_all=[]; for k=1:1:length(d); B_all=[B_all, d(k).C.B]; end; swarm.C.B_all=B_all'; clear B_all;
;
figure;
load coast_mmap.dat;                       % Earth's coast data
[row_start,col]=find(coast_mmap(:,1)==-2); % ---
row_stop=[row_start(2:end)-1;length(coast_mmap(:,1))];
for kl=1:1:length(row_start)               % --
  plot(coast_mmap(row_start(kl):row_stop(kl),3),coast_mmap(row_start(kl):row_stop(kl),2),'r','Linewidth',2); hold on;
end                                        % -)
view(0,90);
zoom on; grid on
set(gca,'ylim',[-90 +90]);
set(gca,'xlim',[-180 +180]);
set(gca,'FontSize',20); set(gca,'Box','on');
;
[plate_name,p]=plate_boundaries_read('PB2002_boundaries.dig.txt');
plot(p.lat,p.long,'b.'); hold on;

[orogons,p_orogon]=plate_boundaries_read('PB2002_orogens.dig.txt');
plot(p_orogon.lat,p_orogon.long,'g.'); hold on;

plot(swarm.A.long_all,swarm.A.lat_all); hold on;
plot(swarm.B.long_all,swarm.B.lat_all); hold on;
plot(swarm.C.long_all,swarm.C.lat_all); hold on;


event_span=swarm_event_latlong.event_span;
%latitude.min=swarm_event_latlong.lat-event_span-8; latitude.max=swarm_event_latlong.lat+event_span+8; % enlarge under spacial cases
latitude.min=swarm_event_latlong.lat-event_span; latitude.max=swarm_event_latlong.lat+event_span;
longitude.min=swarm_event_latlong.long-event_span; longitude.max=swarm_event_latlong.long+event_span; %longitude.min=-180; longitude.max=180;

;
% Sat_A
latitude.index=find((swarm.A.lat_all >= latitude.min) & (swarm.A.lat_all < latitude.max));       % latitude selection
longitude.index=find((swarm.A.long_all >= longitude.min) & (swarm.A.long_all < longitude.max));  % longitude selection
long_lat_intersect_ind=intersect(longitude.index,latitude.index);                                % common lat/long area 
swarm_event.A.t=swarm.A.t(long_lat_intersect_ind);
switch isempty(long_lat_intersect_ind)
case 1 
  fprintf('\n%s\n','No intersection area with the box for SWARM Sat A (increase box)');
  swarm_event.A.B_target_all=[]; swarm_event.A.B_firstdiff_detrend_all=[]; swarm_event.A.long_lat_intersect_ind=[];
  swarm_event.A.X.B_firstdiff_detrend_all=[];swarm_event.A.Y.B_firstdiff_detrend_all=[];swarm_event.A.Z.B_firstdiff_detrend_all=[];
case 0
  gap=long_lat_intersect_ind-long_lat_intersect_ind([2:end,end]);
  gap_up=find(gap ~= -1);
  gap_down=[1;gap_up(1:end-1)+1];
  gap_delta=[gap_up-gap_down+1];
  index_gap_all=[gap_down, gap_up];
  if size(index_gap_all,1)==1; 
    index_gap_all_delta=[long_lat_intersect_ind(index_gap_all)',gap_delta]; % Segment list for detrending
  else
    index_gap_all_delta=[long_lat_intersect_ind(index_gap_all),gap_delta];  % Segment list for detrending
  end
  B_firstdiff_detrend_all=[]; X.B_firstdiff_detrend_all=[];Y.B_firstdiff_detrend_all=[];Z.B_firstdiff_detrend_all=[];X.Bx=[];Y.By=[];Z.Bz=[];X.lBx=[];Y.lBy=[];Z.lBz=[];
  for segments=1:1:size(index_gap_all_delta,1);
    Bx{segments}=swarm.A.B_all(index_gap_all_delta(segments,1):index_gap_all_delta(segments,2),1); % 1/2/3 = Bx/By/Bz
    By{segments}=swarm.A.B_all(index_gap_all_delta(segments,1):index_gap_all_delta(segments,2),2); % 1/2/3 = Bx/By/Bz
    Bz{segments}=swarm.A.B_all(index_gap_all_delta(segments,1):index_gap_all_delta(segments,2),3); % 1/2/3 = Bx/By/Bz
    [xdDWTx] = wdenoise(Bx{segments}); X.B_firstdiff_detrend{segments}=(Bx{segments}-xdDWTx);
    [xdDWTy] = wdenoise(By{segments}); Y.B_firstdiff_detrend{segments}=(By{segments}-xdDWTy);
    [xdDWTz] = wdenoise(Bz{segments}); Z.B_firstdiff_detrend{segments}=(Bz{segments}-xdDWTz);
    X.B_firstdiff_detrend_all=[X.B_firstdiff_detrend_all;X.B_firstdiff_detrend{segments}];
    Y.B_firstdiff_detrend_all=[Y.B_firstdiff_detrend_all;Y.B_firstdiff_detrend{segments}];
    Z.B_firstdiff_detrend_all=[Z.B_firstdiff_detrend_all;Z.B_firstdiff_detrend{segments}];
    X.Bx=[X.Bx;Bx{segments}]; X.lBx=[X.lBx;length(Bx{segments})];
    Y.By=[Y.By;By{segments}]; Y.lBy=[Y.lBy;length(By{segments})];
    Z.Bz=[Z.Bz;Bz{segments}]; Z.lBz=[Z.lBz;length(Bz{segments})];
  end
  swarm_event.A.X.B_firstdiff_detrend_all=X.B_firstdiff_detrend_all; swarm_event.A.X.Bx=X.Bx; swarm_event.A.X.lBx=X.lBx;
  swarm_event.A.Y.B_firstdiff_detrend_all=Y.B_firstdiff_detrend_all; swarm_event.A.Y.By=Y.By; swarm_event.A.Y.lBy=Y.lBy;
  swarm_event.A.Z.B_firstdiff_detrend_all=Z.B_firstdiff_detrend_all; swarm_event.A.Z.Bz=Z.Bz; swarm_event.A.Z.lBz=Z.lBz;
  swarm_event.A.long_lat_intersect_ind=long_lat_intersect_ind;
  swarm_event.A.long=swarm.A.long_all(long_lat_intersect_ind); swarm_event.A.lat=swarm.A.lat_all(long_lat_intersect_ind);
  plot(swarm.A.long_all(long_lat_intersect_ind),swarm.A.lat_all(long_lat_intersect_ind),'Color','cyan','Marker','*','MarkerSize',2); hold on;
end
% Sat_B
latitude.index=find((swarm.B.lat_all >= latitude.min) & (swarm.B.lat_all < latitude.max));      % latitude selection 
longitude.index=find((swarm.B.long_all >= longitude.min) & (swarm.B.long_all < longitude.max)); % longitude selection 
long_lat_intersect_ind=intersect(longitude.index,latitude.index);                               % common lat/long area
swarm_event.B.t=swarm.B.t(long_lat_intersect_ind);
switch isempty(long_lat_intersect_ind)
case 1 
  fprintf('\n%s\n','No intersection area with the box for SWARM Sat B (increase box)');
  swarm_event.B.B_target_all=[]; swarm_event.B.B_firstdiff_detrend_all=[]; swarm_event.B.long_lat_intersect_ind=[];
  swarm_event.B.X.B_firstdiff_detrend_all=[];swarm_event.B.Y.B_firstdiff_detrend_all=[];swarm_event.B.Z.B_firstdiff_detrend_all=[];
case 0
  gap=long_lat_intersect_ind-long_lat_intersect_ind([2:end,end]);
  gap_up=find(gap ~= -1);
  gap_down=[1;gap_up(1:end-1)+1];
  gap_delta=[gap_up-gap_down+1];
  index_gap_all=[gap_down, gap_up];
  if size(index_gap_all,1)==1; 
    index_gap_all_delta=[long_lat_intersect_ind(index_gap_all)',gap_delta]; % Segment list for detrending
  else
    index_gap_all_delta=[long_lat_intersect_ind(index_gap_all),gap_delta];  % Segment list for detrending
  end
  B_firstdiff_detrend_all=[]; X.B_firstdiff_detrend_all=[];Y.B_firstdiff_detrend_all=[];Z.B_firstdiff_detrend_all=[];X.Bx=[];Y.By=[];Z.Bz=[];X.lBx=[];Y.lBy=[];Z.lBz=[];
  for segments=1:1:size(index_gap_all_delta,1);
    Bx{segments}=swarm.B.B_all(index_gap_all_delta(segments,1):index_gap_all_delta(segments,2),1); % 1/2/3 = Bx/By/Bz
    By{segments}=swarm.B.B_all(index_gap_all_delta(segments,1):index_gap_all_delta(segments,2),2); % 1/2/3 = Bx/By/Bz
    Bz{segments}=swarm.B.B_all(index_gap_all_delta(segments,1):index_gap_all_delta(segments,2),3); % 1/2/3 = Bx/By/Bz
    [xdDWTx] = wdenoise(Bx{segments}); X.B_firstdiff_detrend{segments}=(Bx{segments}-xdDWTx);
    [xdDWTy] = wdenoise(By{segments}); Y.B_firstdiff_detrend{segments}=(By{segments}-xdDWTy);
    [xdDWTz] = wdenoise(Bz{segments}); Z.B_firstdiff_detrend{segments}=(Bz{segments}-xdDWTz);
    X.B_firstdiff_detrend_all=[X.B_firstdiff_detrend_all;X.B_firstdiff_detrend{segments}];
    Y.B_firstdiff_detrend_all=[Y.B_firstdiff_detrend_all;Y.B_firstdiff_detrend{segments}];
    Z.B_firstdiff_detrend_all=[Z.B_firstdiff_detrend_all;Z.B_firstdiff_detrend{segments}];
    X.Bx=[X.Bx;Bx{segments}]; X.lBx=[X.lBx;length(Bx{segments})];
    Y.By=[Y.By;By{segments}]; Y.lBy=[Y.lBy;length(By{segments})];
    Z.Bz=[Z.Bz;Bz{segments}]; Z.lBz=[Z.lBz;length(Bz{segments})];
  end
  swarm_event.B.X.B_firstdiff_detrend_all=X.B_firstdiff_detrend_all; swarm_event.B.X.Bx=X.Bx; swarm_event.B.X.lBx=X.lBx;
  swarm_event.B.Y.B_firstdiff_detrend_all=Y.B_firstdiff_detrend_all; swarm_event.B.Y.By=Y.By; swarm_event.B.Y.lBy=Y.lBy;
  swarm_event.B.Z.B_firstdiff_detrend_all=Z.B_firstdiff_detrend_all; swarm_event.B.Z.Bz=Z.Bz; swarm_event.B.Z.lBz=Z.lBz;
  swarm_event.B.long_lat_intersect_ind=long_lat_intersect_ind;
  swarm_event.B.long=swarm.B.long_all(long_lat_intersect_ind); swarm_event.B.lat=swarm.B.lat_all(long_lat_intersect_ind);
  plot(swarm.B.long_all(long_lat_intersect_ind),swarm.B.lat_all(long_lat_intersect_ind),'Color','magenta','Marker','>','MarkerSize',2); hold on;
end
% Sat_C
latitude.index=find((swarm.C.lat_all >= latitude.min) & (swarm.C.lat_all < latitude.max));      % latitude selection
longitude.index=find((swarm.C.long_all >= longitude.min) & (swarm.C.long_all < longitude.max)); % longitude selection
long_lat_intersect_ind=intersect(longitude.index,latitude.index);                               % common lat/long area
swarm_event.C.t=swarm.C.t(long_lat_intersect_ind);
switch isempty(long_lat_intersect_ind)
case 1 
  fprintf('\n%s\n','No intersection area with the box for SWARM Sat C (increase box)');
  swarm_event.C.B_target_all=[]; swarm_event.C.B_firstdiff_detrend_all=[]; swarm_event.C.long_lat_intersect_ind=[];
  swarm_event.C.X.B_firstdiff_detrend_all=[];swarm_event.C.Y.B_firstdiff_detrend_all=[];swarm_event.C.Z.B_firstdiff_detrend_all=[];
case 0
  gap=long_lat_intersect_ind-long_lat_intersect_ind([2:end,end]);
  gap_up=find(gap ~= -1);
  gap_down=[1;gap_up(1:end-1)+1];
  gap_delta=[gap_up-gap_down+1];
  index_gap_all=[gap_down, gap_up];
  if size(index_gap_all,1)==1; 
    index_gap_all_delta=[long_lat_intersect_ind(index_gap_all)',gap_delta]; % Segment list for detrending
  else
    index_gap_all_delta=[long_lat_intersect_ind(index_gap_all),gap_delta];  % Segment list for detrending
  end
  B_firstdiff_detrend_all=[]; X.B_firstdiff_detrend_all=[];Y.B_firstdiff_detrend_all=[];Z.B_firstdiff_detrend_all=[];X.Bx=[];Y.By=[];Z.Bz=[];X.lBx=[];Y.lBy=[];Z.lBz=[];
  for segments=1:1:size(index_gap_all_delta,1);
    Bx{segments}=swarm.C.B_all(index_gap_all_delta(segments,1):index_gap_all_delta(segments,2),1); % 1/2/3 = Bx/By/Bz
    By{segments}=swarm.C.B_all(index_gap_all_delta(segments,1):index_gap_all_delta(segments,2),2); % 1/2/3 = Bx/By/Bz
    Bz{segments}=swarm.C.B_all(index_gap_all_delta(segments,1):index_gap_all_delta(segments,2),3); % 1/2/3 = Bx/By/Bz
    [xdDWTx] = wdenoise(Bx{segments}); X.B_firstdiff_detrend{segments}=(Bx{segments}-xdDWTx);
    [xdDWTy] = wdenoise(By{segments}); Y.B_firstdiff_detrend{segments}=(By{segments}-xdDWTy);
    [xdDWTz] = wdenoise(Bz{segments}); Z.B_firstdiff_detrend{segments}=(Bz{segments}-xdDWTz);
    X.B_firstdiff_detrend_all=[X.B_firstdiff_detrend_all;X.B_firstdiff_detrend{segments}];
    Y.B_firstdiff_detrend_all=[Y.B_firstdiff_detrend_all;Y.B_firstdiff_detrend{segments}];
    Z.B_firstdiff_detrend_all=[Z.B_firstdiff_detrend_all;Z.B_firstdiff_detrend{segments}];
    X.Bx=[X.Bx;Bx{segments}]; X.lBx=[X.lBx;length(Bx{segments})];
    Y.By=[Y.By;By{segments}]; Y.lBy=[Y.lBy;length(By{segments})];
    Z.Bz=[Z.Bz;Bz{segments}]; Z.lBz=[Z.lBz;length(Bz{segments})];
  end
  swarm_event.C.X.B_firstdiff_detrend_all=X.B_firstdiff_detrend_all; swarm_event.C.X.Bx=X.Bx; swarm_event.C.X.lBx=X.lBx;
  swarm_event.C.Y.B_firstdiff_detrend_all=Y.B_firstdiff_detrend_all; swarm_event.C.Y.By=Y.By; swarm_event.C.Y.lBy=Y.lBy;
  swarm_event.C.Z.B_firstdiff_detrend_all=Z.B_firstdiff_detrend_all; swarm_event.C.Z.Bz=Z.Bz; swarm_event.C.Z.lBz=Z.lBz;
  swarm_event.C.long_lat_intersect_ind=long_lat_intersect_ind;
  swarm_event.C.long=swarm.C.long_all(long_lat_intersect_ind); swarm_event.C.lat=swarm.C.lat_all(long_lat_intersect_ind);
  plot(swarm.C.long_all(long_lat_intersect_ind),swarm.C.lat_all(long_lat_intersect_ind),'Color','yellow','Marker','+','MarkerSize',2); hold on;
end
rectangle('Position',[longitude.min,latitude.min,longitude.max-longitude.min,latitude.max-latitude.min],'FaceColor','none','EdgeColor',[.8 .8 .8],'LineWidth',1,'LineStyle','--')
plot3(swarm_event_latlong.long,swarm_event_latlong.lat,0,'color',[0 1 0],'Marker','o','MarkerSize',2*swarm_event_latlong.mag,'MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[1 0 0]); hold on;
xlabel('Longitude (deg)'), ylabel('Latitude (deg)'); title(['SWARM A (cyan), B (magenta), C (yellow) - ',num2str(event(1),'%04d'),num2str(event(2),'%02d'),num2str(event(3),'%02d'),' Span: ',num2str(event_span)]);
set(gcf,'WindowState','maximized');
print('-djpeg100','-r150',['swarm_map_',num2str(event(1),'%04d'),num2str(event(2),'%02d'),num2str(event(3),'%02d'),'-',num2str(event_span),'.jpg']); % jpg graphics output
%savefig(['swarm_map_',num2str(event(1),'%04d'),num2str(event(2),'%02d'),num2str(event(3),'%02d'),'.fig']);
