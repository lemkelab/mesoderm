function PlotEmbryo(coordinates, alpha, allpoints)
%Plot the embryo as a surface scaffold. Optionally showing all the nuclei center of
%masses in grey.  allpoints == 1: points plotted, allpoints == 0: no points plotted
%Needs external function alphavol

coordinates = double(coordinates(:,1:3));
%figure
[V,S] = alphavol(coordinates, alpha,1);

hold on
if allpoints ~= 0
    %scatter3(coordinates(:,1), coordinates(:,2),coordinates(:,3), 40,coordinates(:,3),'filled') %''.','MarkerEdgeColor', [0.8,0.8,0.8],'MarkerSize', 10);
    plot3(coordinates(:,1), coordinates(:,2),coordinates(:,3),'.','MarkerEdgeColor', [0.2,0.2,0.2],'MarkerSize', 10);

end
grid off
%camlight right; lighting phong
%camlight left; lighting phong
xlabel('x')
ylabel('y')
zlabel('z')

end

