% Test script for comparing the algorithms' performance in terms of number 
% of particles on the simulated track
% For each parameter value, the script generates the simulated track,
% measurements and runs the specified tracking algorithms for a number of
% MC trials
% Note that all algorithms can only track one single target
% Multiple targets with target birth/death, clutter measurements are not
% considered

% Jun Ye Yu
% McGill University
% jun.y.y.yu@mail.mcgill.ca
% Nov. 9th, 2017

warning('off','all');
clear;clc;
% Set path to helper functions
addpath('./DynamicModels/');
addpath('./HelperFunctions/');
addpath('./MeasurementModels/');
addpath('./TrackingAlgorithms/');

% Number of particles for the filter
gossip_vector = 1;%10:5:35;% [1, 5, 10, 25, 50];
N_vector = 500; %[100, 250, 500, 1000];
k_vector = 6;%[1,3];%[1, 3, 6, 10, 20, 50];

% Number of random trials
sim_parameters.no_trials = 200; 

% sim_parameters.max_gossip_iter = 100;

% Flag for parallel run
sim_parameters.parallel = false;

% Flag for visualizing at each time step
sim_parameters.visualizeParticles = true;

% Flag for using gossip or exact aggregate
sim_parameters.gossip = false;

% Tracking algorithms are
% 1. centralized bootstrap PF: BS
% 2. distributed CSS PF 
% 3. distributed LC PF
% 4. distributed Graph PF
alg_lists = {@BSpf, @CSSpf_distributed, @LCpf_distributed, @LADelaunaypf_distributed, @ClusterDelaunaypf_distributed};
sim_parameters.algorithms = alg_lists(5);

% Select the track
sim_parameters.track = 2;

% Loop through each choice of particle number
for i=1:numel(gossip_vector)
    % Set number of particles
    sim_parameters.max_gossip_iter = gossip_vector(i);

    for j=1:numel(k_vector)
        sim_parameters.nbClusters = k_vector(j);
        % Run the simulated track with all selected tracking algorithms 
        % Each filter uses N particles   
        [results, parameters]= runSimulatedTrack(sim_parameters);

        % Store the tracking results
        filename{i} = ['Track3_Clusterpf'];
%         filename{i} = [filename{i}, '_gossip',num2str(parameters.max_gossip_iter)];
        filename{i} = [filename{i},'_k',num2str(parameters.F.cluster.k)];
        filename{i} = [filename{i},'_N',num2str(parameters.F.N)];
        filename{i} = [filename{i},'_trials',num2str(parameters.no_trials)];
        filename{i} = [filename{i},'.mat'];
        save(filename{i}, 'results','parameters');
    end
end