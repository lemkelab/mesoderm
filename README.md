# mesoderm
Matlab scripts and functions used for the quantification of morphologial features during mesodern internalization

+++function[volImage] = ReadTifStack(stackname)
Reads multipage tiff stack into volumetric image

+++function [embryoNodes,embryoFaces] = GenerateEmbryoMesh(volImage, resample, gapsize)
Takes volumetric image and makes a mesh and returns a structure of nodes and faces. 
Includes option to resample mesh and adjust the  maximal size of holes to close  
Needs external library iso2mesh!

+++function PlotEmbryoMesh(embryoNodes,embryoFaces, alpha, embryoName)
Plots mesh of the whole embryo and saved plot as an eps figure
Requires library iso2mesh

+++function [coordinatesWithRoi] = DefineROIforPointsInEmbryo(coordinates, anteriorPosteriotPercentage, lateralPercentage, zPercentage, ventralMidline)
Adds an extra column to the original coordinates to indicate belonging to the ROI for each point. 1 = in ROI, 0 = not in ROI. The parameter 'ventralMidline' can be adjusted if the ventral midline is shifted laterally and is otherwise 0.5. 

+++function GetVentralMeshSide(embryoNodes,embryoNodesROIFaces )
Separates surface objects from the inputep volumetric mesh and keeps the most ventral one. Images with all the found meshes are stored as control.
	
+++function [coordinates] = Readh5ObjectsFile(ProjectFile,folder)
Extracts xyz coordinates of object centroids from an Ilastik object classfication ilp file

+++function [coordinatesfixed ] = FixEmbryoOrientation(coordinates )
Aligns coordinates to orient embryo orientation with the x  = anterior-posterior; y  = lateral axis; z = ventral-dorsal axis

+++function PlotEmbryo(coordinates, alpha, allpoints)
Plot the embryo as a surface scaffold. Optionally showing all the nuclei center of masses in grey.  allpoints == 1: points plotted, allpoints == 0: no points plotted
Requires external function alphavol!

+++function [dallinfo] = DistanceToANYSurface(coordinates, surfpoints, surfaces)
For each point in the coordinate array find the closest face in the mesh and calculate distance to it. Adds an extra column to the coordinate array with the minimal distance to the surface

function distances = DistanceToGeneralVentralSurface(coordinates)
% Generated the alpha hull enclosing the centroids
% For each point in the coordinate array find the closest face in the mesh and calculate distance to it

 +++function allFeatures = GetEmbryoMorphologicalFeatures(Isurfdist, nuclearSize)
 Samples sections of the embryo to calculates the features: epithelial integrity, furrow depth, ingression and maximal cell depth from the array of integrity and distances to cellular surface previously generated with 'GetNucleitoCellSurfaceDistances'.
 Takes argument nuclear size in pixel to normalize the distances.
 
  +++ GenerateCellularSurfaceforRoi
 Processes all tiff stacks in a folder to generate volumetric meshes of the ventral region of interest ROI of an embryo. 

 +++ GetNucleitoCellSurfaceDistances
 Matches nuclei and cellular surface of all embryos in a folder, loads ROI ventral surfaces previously generated with 'GenerateCellularSurfaceforRoi'. Loads nuclei centroids from the nuclei segmentation stored in ilp files. Calculates distances and saves a new cell array with one cell per embryo containing x,y,z coordinates and distances.
 
 
