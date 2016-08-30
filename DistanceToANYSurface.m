function [dallinfo] = DistanceToANYSurface(coordinates, surfpoints, surffaces)
%For each point in the coordinate array find the closest face in the mesh
%and calculate distance to it. Adds an extra column to the coordinate array
%with the minimal distance to the surface

display('Calculating distances..')
distances = zeros(length(coordinates),1);
facecenters = faceCentroids(surfpoints, surffaces);

for i = 1:length(coordinates)
    cp = coordinates(i,1:3);
    if mean(ismember(cp,surfpoints)) == 1
        distances(i) = 0;
    else
    %cp = [coordinates(i,2),coordinates(i,1),coordinates(i,3)];
    DsP = zeros(length(surffaces),1);
    for j = 1: length(surffaces)
        DsP(j) = abs(distancePoints3d(cp, facecenters(j,1:3)));
        
    end
    distances(i) = min(DsP);
    end
end

dallinfo = [coordinates distances];


end
%Function to find calculate distances of points to the hull
