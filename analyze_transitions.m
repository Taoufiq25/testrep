function results = analyze_transitions(ref_signal_name,respo_signal_name,Model_name)

    results = []; % initialize output

    if nargin == 3
        fprintf('Simulation run\n');
        out = sim(Model_name);
        assignin('base', 'out', out);
        ref  = out.logsout.getElement(ref_signal_name).Values;
        sig  = out.logsout.getElement(respo_signal_name).Values;
    elseif nargin == 2
        out = evalin('base','out');
        ref  = out.logsout.getElement(ref_signal_name).Values;
        sig  = out.logsout.getElement(respo_signal_name).Values;
        fprintf('Using existing simulation output\n');
    end

    ts = sig.Time;
    ys = sig.Data;
    
    tr = ref.Time;
    yr = ref.Data;

    % Compute difference in reference signal
    dyr = diff(yr);

    transition_index = [];
   

    % Find transition times
    for k = 1:length(dyr)
        if dyr(k) ~= 0
            transition_index(end+1) = tr(k);  % store index of transition
        end
    end


    if isempty(transition_index)
        return; % no transitions found
    end
    
    start_idx = find(ts >= transition_index(1), 1, 'first') - 1;

    % Initialize results struct array
    %%results = struct('TransitionTime', {}, 'Overshoot', {}, 'RiseTime', {});

    % Analyze each transition
    for i = 1:length(transition_index)
        if i < length(transition_index)
            stop_idx = find(ts >= transition_index(i+1), 1, 'first') - 1;
        else
            stop_idx = length(ts);
        end

        t_seg = ts(start_idx:stop_idx);
        y_seg = ys(start_idx:stop_idx);

        % Final value of this step
        final_val = y_seg(end);

        % Compute step info
        info = stepinfo(y_seg, t_seg, final_val);

        % Store in results
        results(i).TransitionTime = ts(start_idx);
        results(i).Overshoot = info.Overshoot;
        results(i).RiseTime = info.RiseTime;
       

        % Print info
        %if nargin == 2
            fprintf('Transition %d at t = %.3f s: Overshoot = %.2f%%, Rise Time = %.4f s\n', ...
            i, results(i).TransitionTime, results(i).Overshoot, results(i).RiseTime);
        %end
         %info
        start_idx = stop_idx;
        
    end
end
