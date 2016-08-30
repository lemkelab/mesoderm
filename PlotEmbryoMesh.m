function PlotEmbryoMesh(embryoNodes,embryoFaces, alpha, embryoName)
% Plots mesh of the whole embryo and saved plot as an eps figure
% Needs library iso2mesh

plotmesh(embryoNodes,embryoFaces,'FaceAlpha',alpha,'EdgeAlpha', 0.2)
view([0 90])
axis off
h = gcf;
figtitle = char(embryoName);
title(figtitle);
figureName = char(strcat(embryoName, '_Embryo'));
figureNameEPS = char(strcat(figureName, '.eps'));
saveas(h,figureNameEPS,'epsc')

end

