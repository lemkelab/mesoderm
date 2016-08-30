function [coordinatesfixed ] = FixEmbryoOrientation(coordinates )
% Aligns coordinates to orient embryo orientation with the x  = anterior-posterior; y  = lateral axis; z = ventral-dorsal axis

coordinatesfixed = coordinates;
if range(coordinates(:,1)) > range(coordinates(:,2))
    coordinatesfixed(:,1) = coordinates(:,1);
    coordinatesfixed(:,2) = coordinates(:,2);
else
    coordinatesfixed(:,1) = coordinates(:,2);
    coordinatesfixed(:,2) = coordinates(:,1);
end

end

