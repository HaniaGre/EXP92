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

% Define measurement points and days
unique_measurement_points = unique(all_data.('Measurement number'));
unique_days = unique(all_data.DAY);

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

% Plot the radiation levels across all days for each measurement point
figure;
hold on;
for p = 1:length(unique_measurement_points)
    plot(1:length(unique_days), radiation_by_day(p, :), '-o', 'DisplayName', unique_measurement_points{p});
end
hold off;
title('Radiation Levels at Each Measurement Point Across Days');
xlabel('Days');
ylabel('Average Radiation (µSv/h)');
xticks(1:length(unique_days));
xticklabels(unique_days);
legend('show');
grid on;

% Plot a bar chart for average radiation by day
figure;
bar(radiation_by_day, 'grouped');
title('Average Radiation Levels per Measurement Point Across Days');
xlabel('Measurement Points');
ylabel('Average Radiation (µSv/h)');
xticks(1:length(unique_measurement_points));
xticklabels(unique_measurement_points);
legend(unique_days, 'Location', 'BestOutside');
grid on;
