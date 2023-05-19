function [d]=read_swarm_cdf_data(swarm_file)
%Author : Chr. Schirninger
%Purpose: read SWARM cdf data
%Example: d=read_swarm_cdf_data(SW_OPER_MAGC_CA_1B_20131126T220149_20131126T235959_0505_MDR_MAG_CA.cdf)
%Date   : May 2023
%Source : ftp://swarm-diss.eo.esa.int https://earth.esa.int/web/guest/swarm/data-access

[data, info]=cdfread(swarm_file, 'Variable', {'Timestamp','Latitude','Longitude','Radius','Flags_B','B_NEC'});

for k=1:1:length(data); d.t(k)=[todatenum(data{k,1})]; end
d.lat=[data{:,2}];
d.long=[data{:,3}];
d.rad=[data{:,4}];
d.Babs=[data{:,5}];
d.B=[data{:,6}];
