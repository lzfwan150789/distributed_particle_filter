function X_estimate = runFilter(S, F, D, dynamic, obs)
%   Function to run one single trial using a single particle filter
%
%   Inputs:
%       S: Struct containing track parameters
%       F: Struct containing filter parameters
%       D: Struct containing measurement data
%       dynamics: Struct containing dynamic model parameters
%       obs: Struct containing measurement model paraleters
%
%   Output:
%       X_estimate: d x nb_steps matrix of estimated target states where d is
%       the target state dimension
%       position_error: 1 x nb_steps row vector of position estimation error
%
% Jun Ye Yu
% McGill University
% jun.y.y.yu@mail.mcgill.ca
% Nov. 9th, 2017

% Allocate variables to store the final results
X_estimate = zeros(F.d, S.nb_steps); 

% Initialize particles
X_filterRepresentation(:,:,1) = F.initializeState(F);

% Iterate over each time step
for k = 1:S.nb_steps
    % Load data for this time step
    D_single.measurements = D.measurements{k};
    D_single.sensorID = D.sensorID{k};
    D_single.sensorLoc = D.sensorLoc{k};
        
    % Skip the predict step for time step 1
    if (k==1)
        F.initial = true;
    else
        F.initial = false;
    end
    
    % Run the particle filter for a single time step
    X_filterRepresentation(:,:,k) = F.algorithm(X_filterRepresentation(:,:,max(k-1,1)), F, D_single, dynamic, obs);
    
    % State estimate (conditional expectation of particle distribution)
    X_estimate(:,k) = F.mmseStateEstimate(X_filterRepresentation(:,:,k));
end
