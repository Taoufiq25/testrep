classdef TU_A < matlab.unittest.TestCase
    % Unit test class for controller performance
    % Uses analyze_all_transitions to check Overshoot and RiseTime
    % Shows detailed messages for each transition

    properties (Access = private)
        Results             % Results from analyze_all_transitions
        OvershootLimit      % Max allowed overshoot [%]
        RiseTimeLimit       % Max allowed rise time [s]
    end

    methods (TestClassSetup)
        function runSimulation(testCase)
            % Set the performance limits
            testCase.OvershootLimit = 5;   % [%]
            testCase.RiseTimeLimit  = 0.5; % [s]

            % Run the simulation and analyze transitions
            fprintf('Running simulation...\n');
            testCase.Results = analyze_transitions('ref','speed','Simulation_A');
        end
    end

    methods (Test)
        function testOvershoot(testCase)
            overshoots = [testCase.Results.Overshoot];
            for i = 1:length(overshoots)
                fprintf('Transition %d: Overshoot = %.2f%%, Limit = %.2f%%\n', ...
                    i, overshoots(i), testCase.OvershootLimit);
            end
            testCase.verifyLessThanOrEqual(overshoots, testCase.OvershootLimit, ...
                'Some transitions exceeded the Overshoot limit!');
            fprintf('All Overshoot checks passed ✅\n\n');
        end

        function testRiseTime(testCase)
            risetimes = [testCase.Results.RiseTime];
            for i = 1:length(risetimes)
                fprintf('Transition %d: Rise Time = %.4f s, Limit = %.4f s\n', ...
                    i, risetimes(i), testCase.RiseTimeLimit);
            end
            testCase.verifyLessThanOrEqual(risetimes, testCase.RiseTimeLimit, ...
                'Some transitions exceeded the Rise Time limit!');
            fprintf('All Rise Time checks passed ✅\n\n');
        end
    end
end
