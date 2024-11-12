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

% Define approximate coordinates for measurement points
measurement_coords = [
    1, 10; 2, 10; 3, 10; 1, 8; 1, 6; 2, 6; 3, 6; 4, 10; 4, 8; 2.5, 8;
    3, 7; 4, 6; 5, 10; 5, 8; 5, 6; 5, 4; 6, 6; 6, 4; 5, 2; 4, 2; 3, 2; 2, 2; 1, 2
];

% Calculate the average radiation level per measurement point
unique_measurement_points = unique(all_data.('Measurement number'));
radiation_levels = NaN(length(unique_measurement_points), 1);

for i = 1:length(unique_measurement_points)
    idx = strcmp(all_data.('Measurement number'), unique_measurement_points{i});
    radiation_levels(i) = mean(all_data{idx, 'AVG [usv/h]'});
end

% Create a grid for the habitat area
x_range = linspace(min(measurement_coords(:,1))-1, max(measurement_coords(:,1))+1, 100);
y_range = linspace(min(measurement_coords(:,2))-1, max(measurement_coords(:,2))+1, 100);
[x_grid, y_grid] = meshgrid(x_range, y_range);

% Interpolate radiation data over the grid for smooth visualization
radiation_grid = griddata(measurement_coords(:,1), measurement_coords(:,2), radiation_levels, x_grid, y_grid, 'cubic');

% Define a custom colormap (Blue -> Green -> Red for Low -> Medium -> High)
custom_colormap = [
    0, 0, 1;    % Blue for low radiation
    0, 1, 0;    % Green for medium radiation
    1, 0, 0     % Red for high radiation
];

% Apply the custom colormap with color limits
figure;
imagesc(x_range, y_range, radiation_grid);
set(gca, 'YDir', 'normal'); % Correct Y-axis direction
colormap(custom_colormap);
colorbar;
caxis([min(radiation_levels), max(radiation_levels)]); % Set color limits to match radiation range
title('Radiation Intensity Heatmap with Custom Colors');
xlabel('X Coordinate');
ylabel('Y Coordinate');
hold on;

% Overlay measurement points for reference
scatter(measurement_coords(:,1), measurement_coords(:,2), 'bo', 'filled');
text(measurement_coords(:,1), measurement_coords(:,2), unique_measurement_points, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', 'Color', 'white');
hold off;
