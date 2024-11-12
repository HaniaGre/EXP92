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

% Load the radiation data
all_data = readtable('Radiation map - ALL DATA.csv', 'VariableNamingRule', 'preserve');

% Define unique days and measurement points
unique_days = unique(all_data.DAY);
unique_measurement_points = unique(all_data.('Measurement number'));

% Initialize matrix to store average radiation levels for each day and point
radiation_by_day = NaN(length(unique_measurement_points), length(unique_days));

% Loop through each day and measurement point to calculate average radiation levels
for d = 1:length(unique_days)
    for p = 1:length(unique_measurement_points)
        % Filter data for the specific day and measurement point
        day_idx = strcmp(all_data.DAY, unique_days{d});
        point_idx = strcmp(all_data.('Measurement number'), unique_measurement_points{p});
        idx = day_idx & point_idx;
        
        % Calculate the average radiation level for the current day and point
        radiation_by_day(p, d) = mean(all_data{idx, 'AVG [usv/h]'}, 'omitnan');
    end
end

% Calculate median and MAD (Median Absolute Deviation) for each day across points
median_radiation = median(radiation_by_day, 1, 'omitnan');
mad_radiation = mad(radiation_by_day, 1, 1); % MAD calculated across points for each day

% Set anomaly detection threshold (e.g., values > 3*MAD from the median are anomalies)
threshold_factor = 3;
upper_threshold = median_radiation + threshold_factor * mad_radiation;
lower_threshold = median_radiation - threshold_factor * mad_radiation;

% Identify anomalies by checking which days have points outside the thresholds
anomaly_points = (radiation_by_day > upper_threshold) | (radiation_by_day < lower_threshold);

% Display summary of anomalies
disp('Anomalous Radiation Levels Detected:');
for d = 1:length(unique_days)
    if any(anomaly_points(:, d))
        fprintf('Day: %s - Anomalous Measurement Points: ', unique_days{d});
        disp(unique_measurement_points(anomaly_points(:, d)));
    end
end

% Visualization: Plot radiation levels with anomaly detection thresholds
figure;
hold on;
for d = 1:length(unique_days)
    plot(1:length(unique_measurement_points), radiation_by_day(:, d), '-o', 'DisplayName', unique_days{d});
    % Highlight anomalies
    plot(find(anomaly_points(:, d)), radiation_by_day(anomaly_points(:, d), d), 'ro', 'MarkerSize', 8, 'DisplayName', 'Anomaly');
end
hold off;
title('Radiation Levels by Day with Anomaly Detection');
xlabel('Measurement Points');
ylabel('Average Radiation (µSv/h)');
legend('show');
grid on;
