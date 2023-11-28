require 'date'

def calculate_reimbursements(project_sets, reimbursement_rates)
    total_reimbursements = project_sets.map do |set|
        calculate_reimbursement_for_set(set['projects'], reimbursement_rates)
    end
end

def calculate_reimbursement_for_set(projects, rates)
    # Initialize variables to track days and total reimbursement
    total_reimbursement = 0
    processed_days = {}

    # Map projects to parse dates
    projects = projects.map do |project|
        project['start_date'] = Date.parse(project['start_date'])
        project['end_date'] = Date.parse(project['end_date'])
        project
    end

    # Sort projects by start date
    sorted_projects = projects.sort_by { |project| project['start_date'] }

    # Process each project
    sorted_projects.each do |project|
        city_cost = project['city_cost']
        # Iterate through each day of the project
        (project['start_date']..project['end_date']).each do |day|
            updatedDay = {}
            if processed_days[day]
                updatedDay = processed_days[day].dup
                # overlapping days are always full days
                updatedDay['day_type'] = 'full'
                # always use the high cost if any day is high cost
                updatedDay['city_cost'] = processed_days[day]['city_cost'] === 'high' ? 'high' : city_cost
                updatedDay['rate'] = rates["#{updatedDay['city_cost']}_cost_city"]['full']
            else
                updatedDay = process_day(day, project, sorted_projects, rates)
            end
            processed_days[day] = updatedDay
        end
    end

    # Calculate reimbursement from processed days
    processed_days.each do |day, day_data|
        total_reimbursement += day_data['rate']
    end
    total_reimbursement
end

def process_day(day, project, sorted_projects, rates)

    # Check for overlaps and gaps
    project_index = sorted_projects.index(project)
    next_project = sorted_projects[project_index + 1] if project_index < sorted_projects.length - 1
    last_project = sorted_projects[project_index - 1] if project_index > 0

    day_type = 'full'

    # if the first day of the first project it is a travel day
    if project_index == 0 && day == project['start_date']
        day_type = 'travel'
    end
    
    # if the last day of the last project it is a travel day
    if project_index == sorted_projects.length - 1 && day == project['end_date']
        day_type = 'travel'
    end

    # if the last project there is a gap between the last project and this one
    if last_project && day == project['start_date']
        last_end_date = last_project['end_date']
        # Check for a gap
        if last_end_date < project['start_date'] - 1
            day_type = 'travel'
        end
    end

    if next_project && day == project['end_date']
        next_start_date = next_project['start_date']
        # Check for a gap
        if next_start_date > project['end_date'] + 1
            day_type = 'travel'
        end
    end
    {
        'day_type' => day_type,
        'city_cost' => project['city_cost'],
        'rate' => rates["#{project['city_cost']}_cost_city"][day_type]
    }
end