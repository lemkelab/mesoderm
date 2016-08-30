function distances = DistanceToGeneralVentralSurface(coordinates, zthreshold)
% Generated the alpha hull enclosing the centroids
% For each point in the coordinate array under the given zthreshold find the closest face in the mesh and calculate distance to it

coordinates = double(coordinates);

[V,S] = alphavol(coordinates, 9000);
%hold on

for i = 1:length(coordinates)  
        % set imposible maximal value for a distance
        distances(i) = 100000;
        % if point belongs to boundary, distance = 0
        if ismember(i,unique(S.bnd))
            distances(i) = 0;
        else
            % else look for interseaction between line and point
            P1 = coordinates(i,:);
            P2 = coordinates(i,:);
            P2(3) = 0;
            L = createLine3d(P1, P2);
            
            DsP = ones(length(S.bnd(:,1)),1);
            
            for j = 1: length(S.bnd)
                p1 = coordinates(S.bnd(j,1),:);
                p2 = coordinates(S.bnd(j,2),:);
                p3 = coordinates(S.bnd(j,3),:);
                
                if(p1(3) < zthreshold && p2(3) < zthreshold && p3(3) < zthreshold)
                    P = createPlane(p1, p2, p3);
                    IntP = intersectLinePlane(L, P);

                    D = distancePoints3d(P1, IntP);
                    DsP(j) = abs(D);

                else
                    DsP(j) = 1000;
                end
            end
            
            distances(i) = min(DsP);
            
        end
end

distances = transpose(distances);

end
