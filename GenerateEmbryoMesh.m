function [embryoNodes,embryoFaces] = GenerateEmbryoMesh(volImage, resample, gapsize)
% Takes volumetric image and makes a mesh and returns a structure of nodes
% and faces with 
% Optional values:
% 'resample': takes values for percentage of resampling in
% the range of 0-1.
% 'gapsize': sets maximal size of holes to close default 20 px
% Needs library iso2mesh
display('Generating embryo mesh...')

%Default value for gap size
if ~exist('gapsize','var')
    gapsize = 20;
end

V = fillholes3d(volImage,gapsize);

%generate mesh
clear opt
opt.radbound= 1;
opt.maxnode = 100000;
[nodes,triangles]= vol2surf(V>0,1:size(V,1),1:size(V,2),1:size(V,3),opt,1);

%resample 
if ~exist('resample','var')
    embryoNodes = nodes;
    embryoFaces = triangles;
else
    [embryoNodes,embryoFaces] = meshresample(nodes,triangles,resample);
end


end

