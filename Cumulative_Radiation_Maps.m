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

% Define coordinates for each measurement point (approximate positions based on layout)
measurement_coords = [
    1, 10; 2, 10; 3, 10; 1, 8; 1, 6; 2, 6; 3, 6; 4, 10; 4, 8; 2.5, 8;
    3, 7; 4, 6; 5, 10; 5, 8; 5, 6; 5, 4; 6, 6; 6, 4; 5, 2; 4, 2; 3, 2; 2, 2; 1, 2
];

% Define all measurement points and calculate cumulative radiation
unique_measurement_points = unique(all_data.('Measurement number'));
cumulative_radiation_levels = NaN(length(unique_measurement_points), 1);

for i = 1:length(unique_measurement_points)
    idx = strcmp(all_data.('Measurement number'), unique_measurement_points{i});
    cumulative_radiation_levels(i) = sum(all_data{idx, 'AVG [usv/h]'}, 'omitnan'); % Sum radiation over all days
end

% Create a grid for interpolation
x_range = linspace(min(measurement_coords(:,1))-1, max(measurement_coords(:,1))+1, 100);
y_range = linspace(min(measurement_coords(:,2))-1, max(measurement_coords(:,2))+1, 100);
[x_grid, y_grid] = meshgrid(x_range, y_range);

% Interpolate cumulative radiation data over the grid for smooth visualization
radiation_grid = griddata(measurement_coords(:,1), measurement_coords(:,2), cumulative_radiation_levels, x_grid, y_grid, 'linear'); % Use 'linear' to handle collinear points

% Plot the 3D cumulative radiation map for the entire habitat
figure;
surf(x_grid, y_grid, radiation_grid, 'EdgeColor', 'none'); % 3D surface plot
colormap hot; % Use a "hot" colormap to represent cumulative intensity
colorbar;
title('Cumulative Radiation Intensity for Entire Habitat (3D)');
xlabel('X Coordinate');
ylabel('Y Coordinate');
zlabel('Cumulative Radiation (µSv/h)');
hold on;

% Overlay measurement points for reference
scatter3(measurement_coords(:,1), measurement_coords(:,2), cumulative_radiation_levels, 100, 'ko', 'filled');
for j = 1:length(unique_measurement_points)
    text(measurement_coords(j,1), measurement_coords(j,2), cumulative_radiation_levels(j), ...
        unique_measurement_points{j}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', 'Color', 'white');
end

hold off;
view(3); % Set the view to 3D
