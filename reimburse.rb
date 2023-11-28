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
            updated_day = {}
            if processed_days[day]
                updated_day = re_process_day(day, processed_days[day], project['city_cost'], rates)              
            else
                updated_day = process_day(day, project, sorted_projects, rates)
            end
            processed_days[day] = updated_day
        end
    end

    # Calculate reimbursement from processed days
    processed_days.each do |day, day_data|
        total_reimbursement += day_data['rate']
    end
    total_reimbursement
end

def re_process_day(day, process_day, project_city_cost, rates)
    updated_day = process_day.dup
    # overlapping days are always full days
    updated_day['day_type'] = 'full'
    # always use the high cost if any day is high cost
    updated_day['city_cost'] = process_day['city_cost'] === 'high' ? 'high' : project_city_cost
    updated_day['rate'] = rates["#{updated_day['city_cost']}_cost_city"]['full']
    updated_day
end

def process_day(day, project, sorted_projects, rates)
    day_type = determine_day_type(day, project, sorted_projects)

    {
        'day_type' => day_type,
        'city_cost' => project['city_cost'],
        'rate' => rates["#{project['city_cost']}_cost_city"][day_type]
    }
end

def determine_day_type(day, project, sorted_projects)
    project_index = sorted_projects.index(project)
    is_first_day = project_index == 0 && day == project['start_date']
    is_last_day = project_index == sorted_projects.length - 1 && day == project['end_date']
    is_gap_before = gap_before_project?(day, project, sorted_projects, project_index)
    is_gap_after = gap_after_project?(day, project, sorted_projects, project_index)

    if is_first_day || is_last_day || is_gap_before || is_gap_after
        'travel'
    else
        'full'
    end
end

def gap_before_project?(day, project, sorted_projects, project_index)
    return false if project_index == 0
    last_project = sorted_projects[project_index - 1]
    last_project['end_date'] < project['start_date'] - 1
end

def gap_after_project?(day, project, sorted_projects, project_index)
    return false if project_index == sorted_projects.length - 1
    next_project = sorted_projects[project_index + 1]
    next_project['start_date'] > project['end_date'] + 1
end