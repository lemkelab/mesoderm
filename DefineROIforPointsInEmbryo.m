function [coordinatesWithRoi] = DefineROIforPointsInEmbryo(coordinates, anteriorPosteriotPercentage, lateralPercentage, zPercentage, ventralMidline)
% Adds an extra column to the original coordinates to indicate belonging to
% the ROI for each point. 1 = in ROI, 0 = not in ROI
% The parameter 'ventralMidline' can be adjusted if
% the ventral midline is shifted laterally and is otherwise 0.5. 
% To plot figure with points in ROI marked in color, set 'plotRoi' == 1

display('Defining ROI for points...')

%check orientation of Embryo

if(max(coordinates(:,1)) > max(coordinates(:,2)))
    xcoordinates = coordinates(:,1);
    ycoordinates = coordinates(:,2);
else
    xcoordinates = coordinates(:,2);
    ycoordinates = coordinates(:,1);
end

xmax = max(xcoordinates);
xmin = min(xcoordinates);
ymax = max(ycoordinates);
ymin = min(ycoordinates);
zmax = max(coordinates(:,3));
zmin = min(coordinates(:,3));

xlength = xmax - xmin;
ylength = ymax - ymin;
zlength = zmax - zmin;

xminthreshold = xmin + ((1-(anteriorPosteriotPercentage/100))/2 * xlength);
xmaxthreshold = xmin + ((1-((1-(anteriorPosteriotPercentage/100))/2)) * xlength);

yminthreshold = ymin + ylength*(ventralMidline - (lateralPercentage/200)); % ymin + ((1-(LRpercentage/100))/2 * ylength);
ymaxthreshold = ymin + ylength*(ventralMidline + (lateralPercentage/200)); %ymin + ((1-((1-(LRpercentage/100))/2)) * ylength);

zthreshold = zmin + zlength*(zPercentage/100);

roiCorrespondance = zeros(length(coordinates),1);

for i = 1:length(coordinates)
    if xcoordinates(i) > xminthreshold && xcoordinates(i) < xmaxthreshold && ycoordinates(i) > yminthreshold && ycoordinates(i) < ymaxthreshold && coordinates(i,3) < zthreshold
        roiCorrespondance(i) = 1;
    end
end

coordinatesWithRoi = [coordinates,roiCorrespondance];

end

