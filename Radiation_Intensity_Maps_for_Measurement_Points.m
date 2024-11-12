% | AUTHOR: Hanna Grechuta |
% | Analog Astronaut Training Center |
% | Expedition 92; 4-13.11.2024 |

% | DESCRIPTION BELOW |

% | This is one of MATLAB CODES, |
% | used in "Analysis of gamma and beta radiation levels in the Habitat" |
% | research paper.|

% | Research paper can be read at this link: |
% | https://linktr.ee/hannagrechuta |

% | This research paper presents the results of beta and gamma radiation |
% | analysis at the Habitat site located in Rzepiennik Strzyżewski |
% | during the analogue mission - expedition no. 92. |

% | Last modified on 10.11.2024 |

% Load the combined dataset
all_data = readtable('Radiation map - ALL DATA.csv', 'VariableNamingRule', 'preserve');

% Display the first few rows to understand the structure
disp('First few rows of the combined dataset:');
disp(head(all_data));

% Check column names and data structure
disp('Column Names:');
disp(all_data.Properties.VariableNames);

% Extract relevant data columns
measurement_points = all_data.('Measurement number'); % Adjust if needed
avg_radiation = all_data.('AVG [usv/h]'); % Adjust if needed
time_period = all_data.DAY; % Adjust if needed

% Group by measurement points and time period, then calculate the mean for each group
grouped_data = groupsummary(all_data, {'Measurement number', 'DAY'}, 'mean', 'AVG [usv/h]');

% Display column names to verify the mean column name
disp('Column Names in grouped_data:');
disp(grouped_data.Properties.VariableNames);

% Extract unique values for plotting
unique_measurement_points = unique(grouped_data.('Measurement number'));
unique_time_periods = unique(grouped_data.DAY);

% Prepare radiation data matrix with aggregated values
radiation_data = NaN(length(unique_measurement_points), length(unique_time_periods));

% Populate the radiation_data matrix with mean values
for i = 1:length(unique_time_periods)
    for j = 1:length(unique_measurement_points)
        % Find the index for the current measurement point and time period
        idx = strcmp(grouped_data.('Measurement number'), unique_measurement_points{j}) & ...
              strcmp(grouped_data.DAY, unique_time_periods{i});
        
        % If there is a match, assign the mean radiation value
        if any(idx)
            radiation_data(j, i) = grouped_data{idx, 'mean_AVG [usv/h]'};
        end
    end
end

% Visualization 1: Bar Plot to Compare Radiation by Time Period
figure;
bar(radiation_data);
title('Average Radiation Intensity (µSv/h) Across All Measurement Points and Days');
xlabel('Measurement Points');
ylabel('Average Radiation (µSv/h)');
xticks(1:length(unique_measurement_points));
xticklabels(unique_measurement_points);
legend(unique_time_periods, 'Location', 'Best');
grid on;

% Visualization 2: Line Plot for Trends Across Measurement Points
figure;
hold on;
for i = 1:length(unique_time_periods)
    plot(1:length(unique_measurement_points), radiation_data(:, i), '-o', 'LineWidth', 1.5);
end
hold off;
title('Radiation Intensity Trends Across Measurement Points and Days');
xlabel('Measurement Points');
ylabel('Average Radiation (µSv/h)');
xticks(1:length(unique_measurement_points));
xticklabels(unique_measurement_points);
legend(unique_time_periods, 'Location', 'Best');
grid on;

% Visualization 3: Heatmap for Radiation Intensity by Measurement Point and Time Period
figure;
imagesc(radiation_data);
colormap hot;
colorbar;
title('Heatmap of Radiation Intensity Across Measurement Points and Time Periods');
xlabel('Time Periods');
ylabel('Measurement Points');
yticks(1:length(unique_measurement_points));
yticklabels(unique_measurement_points);
xticks(1:numel(unique_time_periods));
xticklabels(unique_time_periods);
