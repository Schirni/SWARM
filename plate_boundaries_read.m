function [plate,p]=plate_boundaries_read(pathfile);
% FILE:       plate_boundaries_read.m
% PROGRAMMER: Chr. Schirninger
% PURPOSE:    read plate bpundaries for maps
% FUNCTIONS:  plate_boundaries_read.m
%             [plate_name,p]=plate_boundaries_read('PB2002_boundaries.dig.txt');
% COMMENTS:   
% VERSION:    May 2023
% HISTORY:    
;
% READ FILE
tic;                                                          % start timer
[fid, message]=fopen(pathfile,'rt');                          % open file
if fid == -1                                                  % open not successful
  fprintf('%s\n%s\n',message,'file open fails; wrong filename? wrong path and filename?'); return  % --> WS output
end
plate_nr=1;                                                   % set plate nr to 1
k=1;                                                          % set counter to 1
tline=fgetl(fid);  %fprintf('%s \n',tline);                   % --> get 1st line
while length(tline) > 1                                       % as long as the line has characters ...
  if tline(1) == '*'                                          % end of segment
    %fprintf('%s \n',tline);                                  % *** end of line segment *** 
  elseif tline(1) == ' '                                      % data
    p.lat(k)=str2num(tline(1:13)); p.long(k)=str2num(tline(15:26));
    k=k+1;
  else                                                        % plate name
    plate{plate_nr,:}.name=tline;
    plate_nr=plate_nr+1;
  end
  tline=fgetl(fid);  %fprintf('%s \n',tline);                 % --> get 2nd, 3rd, ... line
end
fclose(fid);                                                  % close file
fprintf('%s %d%s%d\n','Plates/Points from plate boundaries file:',plate_nr-1,'/',k-1);   % --> WS Info
toc;