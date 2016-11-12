function [ F_excl ] = exclusionForce(distanceMatrixFull, objInd, nodeInd, cutoff)
% calculates repulsive exclusion force between agents separated by less
% that cutoff distance
% inputs:
% distance matrix should have dimensions of N objects by M nodes by dimension
% objIdx is the scalar index of the agent upon which the force is to be
% calculated
% cutoff is the scalar radius below which volume exclusion is enforced
% outpus:
% F_excl will be column vector of same dimension

N = size(distanceMatrixFull,1);
M = size(distanceMatrixFull,2);
ndim = size(distanceMatrixFull,3);
distanceMatrix = sqrt(sum(distanceMatrixFull.^2,3)); % reduce to scalar
collisionNbrs = distanceMatrix<=cutoff; % check distance too all other nodes of all other objects
collisionNbrs(objInd,nodeInd) = false; % no self-repulsion
% Nc = nnz(collisionNbrs);
if any(collisionNbrs(:))
    F_excl = sum(... % sum over all collision neighbours
        [distanceMatrixFull(collisionNbrs) distanceMatrixFull(find(collisionNbrs) + N*M)]... %direction FROM neighbours TO object [x, y]
        ./repmat(distanceMatrix(collisionNbrs),1,ndim)... % normalise for distance
        ,1)'; % made into column vector
else
    F_excl = [0, 0];
end
end

